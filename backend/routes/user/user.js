import express from 'express'
import asyncHandler from './../../methods/async-function.js'
import pool from '../../db.js'
import { v4 as uuidv4 } from 'uuid'

import {
	buildFollowUserQuery,
	buildFollowingUserQuery,
	buildUnfollowUserQuery,
	buildUnfollowingUserQuery,
	buildUpdateFollowerCountQuery,
	buildUpdateFollowingCountQuery,
	buildUpdateUnfollowCountQuery,
	buildUpdateUnfollowingCountQuery,
} from './sql-querys.js'

const router = express.Router()

router.post(
	'/new',
	asyncHandler(async (req, res, next) => {
		const { body } = req
		await pool.query(
			`insert into appusers
            (id,
			table_id,
            username,
            name,
            bio,
            avatar_url,
            html_url,
            twitter_username,
            company,
            location,
			email,
			blog,
            projects_count,
			following_count,
			followers_count
            ) values
        ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,0,0,0);`,
			[
				body.id,
				body.table_id,
				body.username,
				body.name,
				body.bio,
				body.avatar_url,
				body.html_url,
				body.twitter_username,
				body.company,
				body.location,
				body.email,
				body.blog,
			]
		)

		await pool.query(
			`CREATE TABLE ${body.table_id}following (
				following_id varchar(255) NOT NULL UNIQUE,
				table_id varchar(255) NOT NULL UNIQUE,
				FOREIGN KEY (following_id) REFERENCES appusers(id)
			);`
		)
		await pool.query(
			`CREATE TABLE ${body.table_id}followers (
				follower_id varchar(255) NOT NULL UNIQUE,
				table_id varchar(255) NOT NULL UNIQUE,
				FOREIGN KEY (follower_id) REFERENCES appusers(id)
			);`
		)
		await pool.query(
			`CREATE TABLE ${body.table_id}likes(
		            liker_user_id varchar(255) NOT NULL,
		            project_id varchar(255) NOT NULL,
		            FOREIGN KEY (liker_user_id) REFERENCES appusers(id),
		            FOREIGN KEY (project_id) REFERENCES allprojects(project_id)
		     );`
		)

		await pool.query(`
			CREATE TABLE ${body.table_id}comments(
		        commenter_user_id varchar(255) NOT NULL,
				project_id varchar(255) NOT NULL,
		        comment TEXT NOT NULL,
		        comment_created_at TIMESTAMP NOT NULL,
			    comment_id varchar(255) NOT NULL UNIQUE,
		        FOREIGN KEY (commenter_user_id) REFERENCES appusers(id),
		        FOREIGN KEY (project_id) REFERENCES allprojects(project_id)
		);`)
		await pool.query(`CREATE TABLE ${body.table_id}notifications (
			notification_id varchar(255) NOT NULL UNIQUE,
			user_id varchar(255) NOT NULL,
			comment TEXT,
			post_id varchar(255) NOT NULL,
			_type varchar(255) NOT NULL,
			follower_id varchar(255) NOT NULL,
			time_at TIMESTAMP NOT NULL
		);`)

		res.status(200).json({
			success: true,
			msg: 'User created successfully',
			results: [],
		})
	})
)
router.get(
	'/isExist/:id',
	asyncHandler(async (req, res, next) => {
		const { id } = req.params
		const { rows } = await pool.query(`SELECT * FROM appusers WHERE id = $1`, [
			id,
		])
		res.status(200).json({
			success: true,
			isExist: rows.length > 0,
		})
	})
)

router.get(
	'/:id',
	asyncHandler(async (req, res, next) => {
		const { id } = req.params
		const { rows } = await pool.query(`select * from appusers where id=$1`, [
			id,
		])
		if (rows.length == 0) {
			return res.status(404).json({
				success: false,
				msg: 'User not found',
				results: [],
			})
		}
		res.status(200).json({
			success: true,
			msg: 'User found',
			results: rows,
		})
	})
)
router.get(
	'/events/isfollow',
	asyncHandler(async (req, res, next) => {
		const { userId, following } = req.query
		const { rows } = await pool.query(
			`SELECT * FROM ${userId}following WHERE following_id = $1`,
			[following]
		)
		res.status(200).json({
			success: true,
			isFollow: rows.length > 0,
		})
	})
)

router.put(
	'/follow',
	asyncHandler(async (req, res, next) => {
		await pool.query(buildFollowUserQuery(req.body))
		await pool.query(buildFollowingUserQuery(req.body))
		await pool.query(buildUpdateFollowerCountQuery(req.body))
		await pool.query(buildUpdateFollowingCountQuery(req.body))
		await pool.query(
			`insert into ${req.body.table_id}notifications (notification_id,user_id,comment,post_id,_type,follower_id,time_at) values ($1,$2,$3,$4,$5,$6,$7)`,
			[uuidv4(), '', '', '', 'FOLLOW', req.body.follower_id, req.body.time_at]
		)
		res.status(200).json({
			success: true,
		})
	})
)
router.put(
	'/unfollow',
	asyncHandler(async (req, res, next) => {
		await pool.query(buildUnfollowUserQuery(req.body))
		await pool.query(buildUnfollowingUserQuery(req.body))
		await pool.query(buildUpdateUnfollowCountQuery(req.body))
		await pool.query(buildUpdateUnfollowingCountQuery(req.body))
		res.status(200).json({
			success: true,
		})
	})
)

router.post(
	'/update',
	asyncHandler(async (req, res, next) => {
		const body = req.body
		await pool.query(
			`update appusers set name = $1, bio = $2, blog = $3, twitter_username = $4, company= $5, location= $6 where id = '${body.id}';`,
			[
				body.name,
				body.bio,
				body.blog,
				body.twitter_username,
				body.company,
				body.location,
			]
		)
		res.status(202).json({
			success: true,
			results: [],
		})
	})
)

router.get(
	'/followers/:id',
	asyncHandler(async (req, res, next) => {
		const { id } = req.params
		const { rows } = await pool.query(`select * from ${id}followers 
	left join appusers on ${id}followers.follower_id = appusers.id;`)
		res.status(200).json({
			success: true,
			results: rows,
		})
	})
)

router.get(
	'/following/:id',
	asyncHandler(async (req, res, next) => {
		const { id } = req.params
		const { rows } = await pool.query(`select * from ${id}following
	left join appusers on ${id}following.following_id = appusers.id;`)
		res.status(200).json({
			success: true,
			results: rows,
		})
	})
)

export default router
