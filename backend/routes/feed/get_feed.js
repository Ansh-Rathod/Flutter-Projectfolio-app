import express from 'express'
import asyncHandler from './../../methods/async-function.js'

import pool from '../../db.js'
const router = express.Router()

router.get(
	'/:id',
	asyncHandler(async (req, res, next) => {
		var { rows } = await pool.query(
			`select * from allprojects
			left join appusers on allprojects.user_id = appusers.id`
		)

		res.status(200).json({
			success: true,
			results: rows,
		})
	})
)
router.get(
	'/tags/:tag',
	asyncHandler(async (req, res, next) => {
		var { rows } = await pool.query(
			`select * from allprojects
			left join appusers on allprojects.user_id = appusers.id where '${req.params.tag}' = ANY(tags)`
		)

		res.status(200).json({
			success: true,
			results: rows,
		})
	})
)

export default router
