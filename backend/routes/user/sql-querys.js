function buildFollowUserQuery(body) {
	return `insert into ${body.table_id}followers (follower_id,table_id) values ('${body.follower_id}','${body.follower_table_id}');`
}

function buildFollowingUserQuery(body) {
	return `insert into ${body.follower_table_id}following (following_id,table_id) values ('${body.user_id}','${body.table_id}');`
}

function buildUnfollowUserQuery(body) {
	return `delete from ${body.table_id}followers where follower_id = '${body.follower_id}';`
}
function buildUnfollowingUserQuery(body) {
	return `delete from ${body.follower_table_id}following where following_id = '${body.user_id}';`
}
function buildUpdateFollowerCountQuery(body) {
	return `update appusers set followers_count=followers_count + 1 where id ='${body.user_id}';`
}
function buildUpdateFollowingCountQuery(body) {
	return `update appusers set following_count=following_count + 1 where id ='${body.follower_id}';`
}
function buildUpdateUnfollowCountQuery(body) {
	return `update appusers set followers_count=followers_count - 1 where id ='${body.user_id}';`
}
function buildUpdateUnfollowingCountQuery(body) {
	return `update appusers set following_count=following_count - 1 where id ='${body.follower_id}';`
}

export {
	buildFollowUserQuery,
	buildFollowingUserQuery,
	buildUnfollowUserQuery,
	buildUnfollowingUserQuery,
	buildUpdateFollowerCountQuery,
	buildUpdateFollowingCountQuery,
	buildUpdateUnfollowCountQuery,
	buildUpdateUnfollowingCountQuery,
}
