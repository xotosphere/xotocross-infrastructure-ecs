const { AutoScalingClient, UpdateAutoScalingGroupCommand } = require('@aws-sdk/client-auto-scaling');

const config = {
  client: new AutoScalingClient(),
  environment: process.env.environment
};

exports.handler = async (event) => {
  const { scalingGroupName, action, capacity } = event;
  console.info(`environment: ${config.environment}`);
  if (action === 'stop') {
    console.info('stopping services and instances...');
    await changeCapacity(scalingGroupName, 0);
  } else if (action === 'start') {
    console.info('starting services and instances...');
    await changeCapacity(scalingGroupName, capacity);
  }
};

const changeCapacity = async (scalingGroupName, capacity) => {
  const params = {
    AutoScalingGroupName: scalingGroupName,
    DesiredCapacity: capacity
  };

  const command = new UpdateAutoScalingGroupCommand(params);
  await config.client.send(command);
  console.info(`desired capacity of ${scalingGroupName} changed to ${capacity}`);
};