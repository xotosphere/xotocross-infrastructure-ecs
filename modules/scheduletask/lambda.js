/**
	{
		"serviceName":"xotocross-core-staging-service",
		"taskCount":0,
		"action":"stop"
	}
*/

const {
    ECSClient,
    UpdateServiceCommand,
    StopTaskCommand,
    ListTasksCommand
} = require('@aws-sdk/client-ecs');

const config = {
	client: new ECSClient({ region: 'eu-west-3' }),
	environment: process.env.environment
};

exports.handler = async ({ serviceName, action, taskCount }) => {
	console.info(`environment: ${config.environment}, serviceName: ${serviceName}, action: ${action}, taskCount: ${taskCount}`);
	action === 'stop' ? await stopTasks(serviceName) : await changeTaskCount(serviceName, taskCount);
};

/**
 * @param {string} serviceName
 * @param {number} taskCount
 */
const changeTaskCount = async (serviceName, taskCount) => {
	await config.client.send(new UpdateServiceCommand({ service: serviceName, desiredCount: taskCount }));
	console.info(`desired task count of ${serviceName} changed to ${taskCount}`);
};

/**
 * @param {string} serviceName
 */
const stopTasks = async (serviceName) => {
	const { taskArns } = await config.client.send(new ListTasksCommand({ serviceName }));
	for (const taskArn of taskArns) await config.client.send(new StopTaskCommand({ task: taskArn }));
	console.info(`all tasks of ${serviceName} stopped`);
};