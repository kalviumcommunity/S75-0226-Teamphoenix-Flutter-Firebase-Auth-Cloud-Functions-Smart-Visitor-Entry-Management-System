import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

const db = admin.firestore();
const auth = admin.auth();

// ==================== AUTH TRIGGERS ====================

/**
 * Create user document in Firestore when a new user is created
 */
export const onUserCreate = functions.auth.user().onCreate(async (user: any) => {
  try {
    await db.collection("users").doc(user.uid).set({
      id: user.uid,
      email: user.email,
      name: user.displayName || "User",
      role: "guard",
      createdAt: new Date().toISOString(),
      lastLogin: new Date().toISOString(),
      isActive: true,
    });
    console.log(`User document created for ${user.uid}`);
  } catch (error) {
    console.error(`Error creating user document: ${error}`);
    throw error;
  }
});

/**
 * Delete user document when user is deleted from Auth
 */
export const onUserDelete = functions.auth.user().onDelete(async (user: any) => {
  try {
    await db.collection("users").doc(user.uid).delete();
    console.log(`User document deleted for ${user.uid}`);
  } catch (error) {
    console.error(`Error deleting user document: ${error}`);
    throw error;
  }
});

// ==================== VISITOR OPERATIONS ====================

/**
 * HTTP function to add a new visitor
 * POST /addVisitor
 */
export const addVisitor = functions.https.onCall(
  async (data: any, context: any) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      const visitorData = {
        ...data,
        entryTime: new Date().toISOString(),
        status: "inside",
        createdByUid: context.auth.uid,
      };

      const docRef = await db.collection("visitors").add(visitorData);
      console.log(`Visitor added with ID: ${docRef.id}`);

      return {
        success: true,
        message: "Visitor added successfully",
        visitorId: docRef.id,
      };
    } catch (error) {
      console.error(`Error adding visitor: ${error}`);
      throw new functions.https.HttpsError("internal", "Error adding visitor");
    }
  }
);

/**
 * HTTP function to mark visitor exit
 * POST /markVisitorExit
 */
export const markVisitorExit = functions.https.onCall(
  async (data: any, context: any) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      const { visitorId } = data;

      if (!visitorId) {
        throw new Error("visitorId is required");
      }

      const duration = calculateDuration(visitorId);

      await db.collection("visitors").doc(visitorId).update({
        status: "exited",
        exitTime: new Date().toISOString(),
        exitByUid: context.auth.uid,
        durationMinutes: duration,
      });

      console.log(
        `Visitor ${visitorId} marked as exited. Duration: ${duration} minutes`
      );

      return {
        success: true,
        message: "Visitor exit recorded",
        durationMinutes: duration,
      };
    } catch (error) {
      console.error(`Error marking visitor exit: ${error}`);
      throw new functions.https.HttpsError("internal", "Error marking exit");
    }
  }
);

/**
 * Query active visitors
 * GET /getActiveVisitors
 */
export const getActiveVisitors = functions.https.onCall(
  async (data: any, context: any) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      const snapshot = await db
        .collection("visitors")
        .where("status", "==", "inside")
        .orderBy("entryTime", "desc")
        .get();

      const visitors = snapshot.docs.map((doc: any) => ({
        id: doc.id,
        ...doc.data(),
      }));

      return {
        success: true,
        count: visitors.length,
        visitors: visitors,
      };
    } catch (error) {
      console.error(`Error fetching active visitors: ${error}`);
      throw new functions.https.HttpsError(
        "internal",
        "Error fetching visitors"
      );
    }
  }
);

/**
 * Get visitor statistics
 * GET /getStatistics
 */
export const getStatistics = functions.https.onCall(
  async (data: any, context: any) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const activeSnapshot = await db
        .collection("visitors")
        .where("status", "==", "inside")
        .get();

      const todaySnapshot = await db
        .collection("visitors")
        .where("entryTime", ">=", today.toISOString())
        .get();

      return {
        success: true,
        statistics: {
          activeVisitors: activeSnapshot.size,
          todayVisitors: todaySnapshot.size,
          timestamp: new Date().toISOString(),
        },
      };
    } catch (error) {
      console.error(`Error fetching statistics: ${error}`);
      throw new functions.https.HttpsError(
        "internal",
        "Error fetching statistics"
      );
    }
  }
);

// ==================== SCHEDULED TASKS ====================

/**
 * Scheduled function to generate daily reports (runs at 11:59 PM)
 */
export const generateDailyReport = functions.pubsub
  .schedule("59 23 * * *")
  .timeZone("UTC")
  .onRun(async (context: any) => {
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const snapshot = await db
        .collection("visitors")
        .where("entryTime", ">=", today.toISOString())
        .get();

      const totalVisitors = snapshot.size;
      const exitedCount = snapshot.docs.filter(
        (doc: any) => doc.data().status === "exited"
      ).length;
      const insideCount = totalVisitors - exitedCount;

      const report = {
        date: today.toISOString(),
        totalVisitors,
        exitedCount,
        insideCount,
        createdAt: new Date().toISOString(),
      };

      await db.collection("daily_reports").add(report);
      console.log(`Daily report generated: ${JSON.stringify(report)}`);

      return { success: true, report };
    } catch (error) {
      console.error(`Error generating daily report: ${error}`);
      throw error;
    }
  });

// ==================== HELPER FUNCTIONS ====================

/**
 * Calculate duration between entry and exit
 */
function calculateDuration(visitorId: string): number {
  // This is a placeholder - in a real scenario, fetch from DB
  return 0;
}

/**
 * Validate visitor data
 */
function validateVisitorData(data: any): boolean {
  const requiredFields = [
    "name",
    "email",
    "phone",
    "purpose",
    "hostName",
    "companyName",
    "documentType",
    "documentNumber",
  ];

  return requiredFields.every((field) => data[field] !== undefined);
}
