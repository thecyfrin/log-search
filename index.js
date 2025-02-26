const admin = require("firebase-admin");

const key = process.env.FIREBASE_ADMIN_CONFIG;
if (!key) {
	throw new Error("FIREBASE_ADMIN_CONFIG is not set! Check your .env file.");
}

const privateKey = JSON.parse(key);

admin.initializeApp({
	credential: admin.credential.cert(privateKey),
	databaseURL: "https://cochevia-default-rtdb.firebaseio.com",
});

const sendSingleNotification = async (token, title, description, tripId) => {
	if (!token) {
		console.log("No valid token provided.");
		return;
	}

	const message = {
		token, // Single token
		notification: {
			title,
			body: description,
		},
		data: {
			tripId: tripId,
		},
		android: { priority: "high" },
		apns: {
			payload: {
				aps: {
					badge: 42,
				},
			},
		},
	};

	try {
		const response = await admin.messaging().send(message);
		console.log("Successfully sent message:", response);
	} catch (error) {
		// Handle specific error codes
		if (
			error.errorInfo &&
			error.errorInfo.code === "messaging/registration-token-not-registered"
		) {
			console.error(`Invalid FCM token detected: ${token}`);
			// Remove the invalid token from your database
		} else {
			console.error("Error sending notification:", error);
		}
	}
};

const sendTestNotification = async (token, title, description) => {
	if (!token) {
		console.log("No valid token provided.");
		return;
	}

	const message = {
		token, // Single token
		notification: {
			title,
			body: description,
		},
		data: {
			data: "20 feb",
		},
		android: { priority: "high" },
		apns: {
			payload: {
				aps: {
					badge: 42,
				},
			},
		},
	};

	try {
		const response = await admin.messaging().send(message);
		console.log("Successfully sent message:", response);
	} catch (error) {
		// Handle specific error codes
		if (
			error.errorInfo &&
			error.errorInfo.code === "messaging/registration-token-not-registered"
		) {
			console.error(`Invalid FCM token detected: ${token}`);
			// Remove the invalid token from your database
		} else {
			console.error("Error sending notification:", error);
		}
	}
};

const sendImageNotification = async (token, title, description, imageUrl) => {
	if (!token) {
		console.log("No valid token provided.");
		return;
	}

	const message = {
		token, // Single token
		notification: {
			title,
			body: description,
			image: imageUrl,
		},
		android: {
			notification: {
				imageUrl: imageUrl,
			},
		},
		data: {
			image: imageUrl,
		},
		apns: {
			payload: {
				aps: {
					"mutable-content": 1,
				},
			},
			fcm_options: {
				image: imageUrl,
			},
		},
	};

	try {
		const response = await admin.messaging().send(message);
		console.log("Successfully sent message:", response);
	} catch (error) {
		// Handle specific error codes
		if (
			error.errorInfo &&
			error.errorInfo.code === "messaging/registration-token-not-registered"
		) {
			console.error(`Invalid FCM token detected: ${token}`);
			// Remove the invalid token from your database
		} else {
			console.error("Error sending notification:", error);
		}
	}
};

module.exports = {
	sendSingleNotification,
	sendTestNotification,
	sendImageNotification,
};
