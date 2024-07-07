/**
	{
		"clusterName":"xotocross-staging-ecs",
		"serviceName":"xotocross-demo-staging-service",
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
	// todo check if we need this eu-west-3 (as its not global)
	client: new ECSClient({ region: 'eu-west-3' }),
	environment: process.env.environment
};

exports.handler = async ({ clusterName, serviceName, action, taskCount }) => {
	console.info(
		`environment: ${config.environment}, serviceName: ${serviceName}, action: ${action}, taskCount: ${taskCount}`
	);
	action === 'stop'
		? await stopTasks(clusterName, serviceName)
		: await changeTaskCount(clusterName, serviceName, taskCount);
};

/**
 * @param {string} serviceName
 * @param {number} taskCount
 */
const changeTaskCount = async (clusterName, serviceName, taskCount) => {
	await config.client.send(
		new UpdateServiceCommand({
			service: serviceName,
			desiredCount: taskCount,
			cluster: clusterName
		})
	);
	console.info(`desired task count of ${serviceName} changed to ${taskCount}`);
};

/**
 * @param {string} serviceName
 */
const stopTasks = async (clusterName, serviceName) => {
	console.info(clusterName);
	const { taskArns } = await config.client.send(
		new ListTasksCommand({ serviceName, cluster: clusterName })
	);
	for (const taskArn of taskArns)
		await config.client.send(
			new StopTaskCommand({ task: taskArn, cluster: clusterName })
		);
	console.info(`all tasks of ${serviceName} stopped`);
};
