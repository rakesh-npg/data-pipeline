import { schema, CustomMessages } from '@ioc:Adonis/Core/Validator'
import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'

export default class LogstashValidator {
  constructor(protected ctx: HttpContextContract) {}

  public schema = schema.create({
    filePath: schema.string(), 
    pipeLine: schema.string(), 
    logstashPath: schema.string(), 
    numLines: schema.number()
    
  })


  public messages: CustomMessages = {}
}
