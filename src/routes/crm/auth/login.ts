import { FastifyInstance, FastifyPluginOptions, FastifyRequest, FastifyReply } from 'fastify';

import { jwtVerify, setJwtCookie } from '../../../utils/jwtUtils';
import { Worker } from '../../../models/worker';
import { USER_WORKER } from '../../../utils/constants';

// TODO: Наладить авторизацию

export default async function(app: FastifyInstance, opts: FastifyPluginOptions) {
    app.post('/', {
        schema: {
            body: {
                type: 'object',
                required: ['email'],
                properties: {
                    email: {
                        type: 'string',
                        maxLength: 50,
                        pattern: '^[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$'
                    }
                }
            }
        }
    }, async (request: FastifyRequest<{
        Body: {
            email: string;
            password: string;
        }
    }>, reply: FastifyReply) => {
        if (request.cookies.token) {
            try {
                await jwtVerify(request.cookies.token); 
                
                reply.statusCode = 409;
                return {
                    error: 'ALREADY_AUTHORIZED'
                };
            } catch {
            }
        }

        const user: Worker = (await opts.db.query('SELECT * FROM worker WHERE email = $1', [request.body.email])).rows[0];
        
        if (!user) {
            reply.statusCode = 401;
            return {
                error: 'INVALID_CREDENTIALS'
            };
        }

        if (user.is_disabled) {
            reply.statusCode = 401;
            return {
                error: 'USER_DISABLED'
            };
        }

        return await setJwtCookie(user.id, USER_WORKER, reply);
    });
}

export const autoPrefix = '/crm/auth/login';
