const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.getReceivedMatches = functions.https.onCall(async (data, context) => {
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }

    const matchesSnapshot = await admin.firestore().collection("matches")
        .where("toUserId", "==", userId)
        .get();

    return matchesSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
    }));
});


exports.sendKakaoIds = functions.https.onCall(async (data, context) => {
    const fromUserId = data.fromUserId;
    const toUserId = data.toUserId;

    const fromUserDoc = await admin.firestore().collection("users").doc(fromUserId).get();
    const toUserDoc = await admin.firestore().collection("users").doc(toUserId).get();

    const fromKakaoId = fromUserDoc.data().kakaoId;
    const toKakaoId = toUserDoc.data().kakaoId;

    await admin.firestore().collection("users").doc(fromUserId).update({
        matchedKakaoId: toKakaoId,
    });

    await admin.firestore().collection("users").doc(toUserId).update({
        matchedKakaoId: fromKakaoId,
    });

    return { success: true };
});

exports.getSentMatches = functions.https.onCall(async (data, context) => {
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }

    const sentMatchesSnapshot = await admin.firestore().collection("matches")
        .where("fromUserId", "==", userId)
        .get();

    return sentMatchesSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
    }));
});
