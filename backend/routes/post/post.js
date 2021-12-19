import express from 'express'
import asyncHandler from './../../methods/async-function.js'
import { v4 as uuidv4 } from 'uuid'

import pool from '../../db.js'
import cloudinary from 'cloudinary'

import formidable from 'formidable'
const { IncomingForm } = formidable
const router = express.Router()
cloudinary.v2.config({
	cloud_name: 'dornu6mmy',
	api_key: '459913161249364',
	api_secret: '9z9buL0YNMYG1aB8w4wh8gaP-3s',
})
router.post(
	'/new',
	asyncHandler(async (req, res, next) => {
		const { body } = req

		await pool.query(
			`insert into
			allprojects
            (
			project_id,
			title,
			github_url,
			description,
			type,
			project_url,
			posted_at,
			user_id,
			likes,
			tags,
			images
			) values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)`,
			[
				body.project_id,
				body.title,
				body.github_url,
				body.description,
				body.type,
				body.project_url,
				body.posted_at,
				body.user_id,
				[],
				body.tags,
				body.images,
			]
		)
		res.status(200).json({
			success: true,
			message: 'Project added successfully',
			results: [],
		})
	})
)

router.post(
	'/upload-images',
	asyncHandler(async (req, res, next) => {
		const data = await new Promise((resolve, reject) => {
			const form = new IncomingForm()
			form.parse(req, (err, fields, files) => {
				if (err) return reject(err)
				resolve({ fields, files })
			})
		})
		console.log(data.files.picture.filepath)
		var result = await cloudinary.v2.uploader.upload(
			data.files.picture.filepath,
			{
				folder: 'projectfoilo',
			}
		)

		res.status(202).json({
			success: true,
			url: result.url,
			data: result,
		})
	})
)

router.get(
	'/:id',
	asyncHandler(async (req, res, next) => {
		const { id } = req.params
		var { rows } = await pool.query(
			`
        	select * from allprojects
			left join appusers on allprojects.user_id = appusers.id where user_id = '${id}';`
		)

		res.status(200).json({
			success: true,
			message: 'Projects fetched successfully',
			results: rows,
		})
	})
)

router.put(
	'/like',
	asyncHandler(async (req, res, next) => {
		const body = req.body

		await pool.query(
			`insert into ${body.table_id}likes (project_id,liker_user_id) values ('${body.project_id}','${body.liker_id}');`
		)
		await pool.query(
			`update allprojects set likes = array_append(likes,'${body.liker_id}') where project_id = '${body.project_id}';`
		)

		await pool.query(`UPDATE allprojects
		SET    likes = ARRAY (
						 SELECT v
						 FROM   unnest(likes) WITH ORDINALITY t(v,ord)
						 GROUP  BY 1
						 ORDER  BY min(ord)
						)
		WHERE  cardinality(likes) > 1  -- optional
		AND    likes <> ARRAY (
						 SELECT v
						 FROM   unnest(likes) WITH ORDINALITY t(v,ord)
						 GROUP  BY 1
						 ORDER  BY min(ord)
						);`)
		if (body.liker_id !== body.user_id) {
			await pool.query(
				`insert into ${body.table_id}notifications (notification_id,user_id,comment,post_id,_type,follower_id,time_at) values ($1,$2,$3,$4,$5,$6,$7)`,
				[
					uuidv4(),
					body.liker_id,
					'',
					body.project_id,
					'LIKE',
					body.liker_id,
					body.time_at,
				]
			)
		}
		res.status(202).json({
			success: true,
			results: [],
		})
	})
)
router.put(
	'/unlike',
	asyncHandler(async (req, res, next) => {
		const body = req.body
		await pool.query(
			`update allprojects set likes = array_remove(likes,'${body.liker_id}') where project_id = '${body.project_id}';`
		)
		await pool.query(
			`delete from ${body.table_id}likes where project_id = '${body.project_id}' and liker_user_id = '${body.liker_id}';`
		)

		res.status(202).json({
			success: true,
			results: [],
		})
	})
)
router.get(
	'/one_post/:id',
	asyncHandler(async (req, res, next) => {
		const { id } = req.params
		const { rows } = await pool.query(`
		select * from allprojects
		left join appusers on allprojects.user_id = appusers.id where project_id ='${id}';
		`)

		res.status(200).json({
			success: true,
			results: rows,
		})
	})
)
router.post(
	'/create-comment',
	asyncHandler(async (req, res, next) => {
		const body = req.body
		await pool.query(
			`insert into ${body.table_id}comments (commenter_user_id, project_id, comment_created_at , comment,comment_id)
			 values
			  ($1,$2,$3,$4,$5);`,
			[
				body.commenter_user_id,
				body.project_id,
				body.comment_created_at,
				body.comment,
				body.comment_id,
			]
		)
		if (body.commenter_user_id !== body.user_id) {
			await pool.query(
				`insert into ${body.table_id}notifications (notification_id,user_id,comment,post_id,_type,follower_id,time_at) values ($1,$2,$3,$4,$5,$6,$7)`,
				[
					uuidv4(),
					body.commenter_user_id,
					body.comment,
					body.project_id,
					'COMMENT',
					body.commenter_user_id,
					body.comment_created_at,
				]
			)
		}
		res.status(200).json({
			success: true,
			message: 'Comment added successfully',
			results: [],
		})
	})
)
router.post(
	'/comments/all',
	asyncHandler(async (req, res, next) => {
		const body = req.body
		const { rows } = await pool.query(`select * from ${body.table_id}comments
    left join appusers ON ${body.table_id}comments.commenter_user_id = appusers.id 
    where project_id = '${body.project_id}';`)

		res.status(200).json({
			success: true,
			results: rows,
		})
	})
)

router.delete(
	'/:id',
	asyncHandler(async (req, res, next) => {
		const { id } = req.params
		const { table_id } = req.query
		await pool.query(`delete from ${table_id}likes where project_id = '${id}'`)
		await pool.query(
			`delete from ${table_id}notifications where post_id = '${id}'`
		)
		await pool.query(
			`delete from ${table_id}comments where project_id = '${id}'`
		)

		await pool.query(`delete from allprojects where project_id = '${id}';`)
		res.status(200).json({
			success: true,
			message: 'Project deleted successfully',
			results: [],
		})
	})
)

export default router
