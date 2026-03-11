/**
 * Copyright IBM Corp. 2014, 2026
 * SPDX-License-Identifier: MPL-2.0
 */

/**
 * HTTP Cloud Function for testing environment variable Secrets.
 */
exports.echoSecret = (req, res) => {
    let message = req.query.message || req.body.message || "Secret: " + process.env.MY_SECRET;
    res.status(200).send(message);
};