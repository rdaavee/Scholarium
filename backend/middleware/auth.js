const jwt = require('jsonwebtoken');
const secretKey = process.env.SECRET_KEY;

const verifyToken = (req, res, next) => {
const token = req.headers['authorization']?.split(' ')[1]; 

if (!token) {
    return res.status(403).json({ message: 'No token provided.' });
    }

    jwt.verify(token, secretKey, (err, decoded) => {
    if (err) {
        console.error('Token verification error:', err);
        return res.status(401).json({ message: 'Unauthorized!' });
    }
    req.userId = decoded.id;
    req.userSchoolId = decoded.school_id;
    next();
    });
};


module.exports = { verifyToken };
