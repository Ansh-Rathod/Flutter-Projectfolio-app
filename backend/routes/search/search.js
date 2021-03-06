import express from 'express'
import asyncHandler from './../../methods/async-function.js'

import pool from '../../db.js'
const router = express.Router()

router.get(
	'/',
	asyncHandler(async (req, res, next) => {
		var data = await pool.query(
			`select * from appusers where LOWER(name) like '%${req.query.q}%'`
		)
		res.status(200).json({
			success: true,
			results: data.rows,
		})
	})
)
router.get(
	'/projects',
	asyncHandler(async (req, res, next) => {
		var data = await pool.query(
			`select * from allprojects left join appusers on allprojects.user_id = appusers.id where LOWER(title) like '%${req.query.q}%'`
		)
		res.status(200).json({
			success: true,
			results: data.rows,
		})
	})
)

export default router
