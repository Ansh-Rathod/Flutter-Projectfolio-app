import express from 'express'
import errorHandler from './middlewares/error.js'
import user from './routes/user/user.js'
import project from './routes/post/post.js'
import search from './routes/search/search.js'
import notifications from './routes/notifications/get-notifications.js'
import feed from './routes/feed/get_feed.js'
import dotenv from 'dotenv'

const app = express()
dotenv.config({ path: './.env' })

app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.get('/', (req, res) => {
	res.send('Hello welcome to Projectfolio backend server')
})
app.use('/api/v1/user', user)
app.use('/api/v1/project', project)
app.use('/api/v1/search', search)
app.use('/api/v1/feed', feed)
app.use('/api/v1/notifications', notifications)
app.use(errorHandler)

const PORT = process.env.PORT || 3000
app.listen(PORT, console.log('Server running on port 3000'))
