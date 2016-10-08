const _ = require('lodash/fp')
const koa = require('koa')
const router = require('koa-route')
const bodyParser = require('koa-bodyparser')
const Promise = require('bluebird')
const fs = Promise.promisifyAll(require('fs'))
const childProcess = Promise.promisifyAll(require('child_process'))

const app = koa()
app.use(bodyParser())
app.use(require('koa-static')(__dirname+'/public'))
app.use(router.all('/redeploy', function *(){
	yield childProcess.execAsync(__dirname+'./pull-project.sh')
	.then(_.partial(childProcess.execAsync, __dirname+'./kill-project.sh'))
	.then(_.constant('done'))
	this.body = "it works."
}))


app.listen(1337)
