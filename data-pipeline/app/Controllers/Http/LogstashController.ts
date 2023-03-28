import { execSync} from "child_process";
import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import LogstashValidator from "App/Validators/LogstashValidator";
import path from 'path'
import ExceptionTypes from "App/Exceptions/ExceptionTypes";

export default class LogstashController {
        public async LogCall({request}:HttpContextContract){
                let { filePath, pipeLine, logstashPath, numLines } = await request.validate(LogstashValidator)
                const scriptPath = path.resolve(__dirname, '../../ShellScripts/logexecute.sh')
                filePath = filePath[filePath.length-1] == '*' ? filePath.slice(0, filePath.length -1) + "'*'" : filePath
                try {
                        const output = execSync(`${scriptPath} -f ${filePath} -n ${numLines} -p ${pipeLine} -l ${logstashPath}`)
                        console.log(Buffer.from(output).toString())
                }
                catch(error) {
                        const data = Buffer.from(error.stdout).toString()
                        const split = data.split('\n')
                        throw ExceptionTypes.internalServerError(split[0])
                }

              
        }

}       

