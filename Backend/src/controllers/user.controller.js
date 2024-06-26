import { loginSchema, registerSchema } from "../../packages/zod.js";
import asyncHandler from "../utils/asyncHandler.js";
import client from "../../db/index.js";
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { z } from "zod";
import { deleteOtp } from "./common.controller.js";
import { messMap } from "../utils/messId.js";
import sendEmail from "../utils/email/index.js";

export const registerUser = asyncHandler(async (req, res) => {
    const { username, name, email, hostel, password, OTP, defaultMess } = req.body;
    // const { success } = registerSchema.safeParse(req.body);
    console.log(req.body);
    // if (!success) {
    //     return res.status(400).json({ message: "Invalid Input" });
    // }

    // try {
    const matched = await client.otp.findFirst({
        where: {
            email,
            key: OTP,
        },
    });

    if (!matched) {
        return res.status(404).json({ message: "Invalid OTP" });
    }

    const currentTime = new Date().getTime();
    const otpExpiry = new Date(matched.expiry).getTime();

    await deleteOtp(email);

    if (currentTime - otpExpiry > 15 * 60 * 1000) {
        return res.status(400).json({ message: "OTP expired" });
    }

    const user = await client.student.create({
        data: {
            name,
            username,
            email,
            hostel: {
                connect: {
                    id: hostel,
                }
            },
            password: password ? await bcrypt.hash(password, 10) : undefined,
            defaultMess
        },
    });

    const payload = { id: user.id };

    const token = jwt.sign(payload, process.env.JWT_SECRET, {
        expiresIn: 3600 * 24 * 30,
    });

    return res.status(200).json({ token, message: "User registered successfully" });
    // } catch (err) {
    //     await deleteOtp(email);

    //     return res.status(403).json(err);
    // }
});

export const loginUser = asyncHandler(async (req, res) => {
    const loginData = req.body;
    console.log(loginData);
    const { success } = loginSchema.safeParse(loginData);

    if (!success) {
        return res.status(400).json({ message: "Invalid Input" });
    }

    const { username, password } = loginData;
    console.log(username, password)

    try {
        const user = await client.student.findUnique({
            where: {
                username
            },
        });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(400).json({ message: "Invalid Credentials" });
        }

        const payload = { id: user.id };

        const token = jwt.sign(payload, process.env.JWT_SECRET, {
            expiresIn: 3600 * 24 * 30,
        });

        return res.status(200).json({ token, message: "User logged in successfully" });
    } catch (err) {
        return res.status(403).json(err);
    }
});

export const getUser = asyncHandler(async (req, res) => {

    const user = await client.student.findFirst({
        where: {
            id: req.user.id,
        },
        select: {
            id: true,
            name: true,
            username: true,
            email: true,
            hostel: {
                select: {
                    id: true,
                    name: true,
                },
            },
            messId: true,
            // feedbacks: true
        },
    });

    if (!user.hostel) {
        user.hostel = "Not Assigned"
    } else {
        user.hostel = user.hostel.name
    }

    // const mess = await client.mess.findFirst({
    //     where: {
    //         id: user.messId,
    //     },
    //     select: {
    //         id: true,
    //         name: true,
    //     },
    // });

    if (user.messId) {
        user.messId = messMap[user.messId];
    } else {
        user.messId = "Not Assigned";
    }

    console.log('controller', user)

    return res.status(200).json({ user });
});

export const updatePassword = asyncHandler(async (req, res) => {
    const { password } = req.body;

    const { success } = z.string().min(6).safeParse(password);

    if (!success) {
        return res.status(400).json({ message: "Invalid Input" });
    }

    try {
        const user = await client.student.update({
            where: {
                id: req.user.id,
            },
            data: {
                password: password ? await bcrypt.hash(password, 10) : undefined,
            },
            select: {
                name: true,
                username: true,
                email: true,
                hostel: true,
                defaultMess: true,
                // mess: {
                //     select: {
                //         id: true,
                //         name: true,
                //         location: true,
                //     },
                // }
            },
        });

        return res.status(200).json(user);
    } catch (err) {
        return res.status(403).json(err);
    }
});

export const updateDefaultMess = asyncHandler(async (req, res) => {
    const { defaultMess } = req.body;

    const { success } = z.string().optional().safeParse(defaultMess);

    if (!success) {
        return res.status(400).json({ message: "Invalid Input" });
    }

    try {
        const user = await client.student.update({
            where: {
                id: req.user.id,
            },
            data: {
                defaultMess: defaultMess ? defaultMess : undefined,
            },
            select: {
                name: true,
                username: true,
                email: true,
                hostel: true,
                defaultMess: true,
                // mess: {
                //     select: {
                //         id: true,
                //         name: true,
                //         location: true,
                //     },
                // }
            },
        });

        return res.status(200).json(user);
    } catch (err) {
        return res.status(403).json(err);
    }
});

export const createFeedback = asyncHandler(async (req, res) => {
    const { title, description, attachment } = req.body;
    console.log('zkldsjfalk', req.body);
    // const { success } = z.object({
    //     type: z.string().min(1),
    //     description: z.string(),
    //     rating: z.number().optional(),
    // }).safeParse(req.body);

    // if (!success) {
    //     return res.status(400).json({ message: "Invalid Input" });
    // }

    // try {
    const user = await client.student.findUnique({
        where: {
            id: req.user.id,
        },
    })

    const feedbackData = await client.feedback.create({
        data: {
            title,
            description,
            attachmenet: attachment,
            studentId: user.id,
            messId: user.messId
        },
    });

    return res.status(200).json(feedbackData);
    // } catch (err) {
    //     return res.status(403).json(err);
    // }
});

export const getFeedbacks = asyncHandler(async (req, res) => {
    try {
        const feedbacks = await client.feedback.findMany({
            where: {
                studentId: req.user.id,
            },
        });

        return res.status(200).json(feedbacks);
    } catch (err) {
        return res.status(403).json(err);
    }
});

export const submitForm = asyncHandler(async (req, res) => {
    const { preferences } = req.body;
    const { success } = z.object({
        preferences: z.array(z.string()),
    }).safeParse(req.body);
    console.log(preferences);
    if (!success) {
        return res.status(400).json({ message: "Invalid Input" });
    }

    try {
        const studentId = req.user.id;
        const user = await client.student.findFirst({
            where: {
                id: studentId,
            },
        });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        const alreadyForm = await client.messForm.findFirst({
            where: {
                studentId,
            },
        });

        const currentTime = new Date();

        const notification = await client.notification.findFirst({
            where: {
                endDate: { gte: currentTime },
                startDate: { lte: currentTime },
            },
        });

        if (alreadyForm && alreadyForm.createdAt > notification.startDate && alreadyForm.createdAt < notification.endDate) {
            return res.status(400).json({ message: "Form already submitted" });
        }

        const form = await client.messForm.create({
            data: {
                studentId,
                preferences,
            },
        });

        await sendEmail({
            mail: req.user.email,
            subject: '🍽️ Response recieved Successfully!',
            text: `Hi there! Your mess prefernce response for this month recieved successfully. We will notify you once the allotment is done.:
        
          Prefernces you choose are: ${preferences.map((pref) => `\n- ${messMap[pref]}`).join('')}
    
        If you have any questions or need assistance, feel free to reach out to our support team.
        
        We can't wait to serve you!
        
        Best regards,
        IIT Mandi Mess Service Team`
        });

        return res.status(200).json(form);
    } catch (err) {
        return res.status(403).json(err);
    }
});

export const verifyQR = asyncHandler(async (req, res) => {
    const { qrMessId } = req.body;
    const { messId } = req.user;
    console.log(qrMessId);
    console.log(messId);
    const { success } = z.object({
        qrMessId: z.string(),
    }).safeParse(req.body);

    if (!success) {
        return res.status(400).json({ message: "Invalid Input" });
    }

    try {
        const matched = qrMessId === messId;
        if (!matched) {
            return res.status(404).json({ msg: 'Not matched' })
        }

        return res.status(200).json({ matched });
    } catch (err) {
        return res.status(403).json(err);
    }
});

export const getFormStatus = asyncHandler(async (req, res) => {
    try {
        const currentTime = new Date();
        // console.log(currentTime.getTime());

        const form = await client.notification.findFirst({
            where: {
                endDate: { gte: currentTime },
                startDate: { lte: currentTime },
            },
        });

        if (!form) {
            return res.status(404).json({ message: "No form available" });
        }

        return res.status(200).json(form);
    } catch (err) {
        return res.status(403).json(err);
    }
});

export const MessOff = asyncHandler(async (req, res) => {
    const { imgUrl, startDate, endDate } = req.body;

    try {
        const data = await client.MessOff.create({
            data: {
                imgUrl,
                startDate: new Date(startDate),
                endDate: new Date(endDate),
                student: {
                    connect: {
                        id: req.user.id,
                    }
                },
            },
        });

        return res.status(200).json(data);

    } catch (err) {
        return res.status(403).json(err);
    }
});