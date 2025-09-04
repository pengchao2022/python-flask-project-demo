#!/bin/bash
set -e

# 配置参数
ALB_NAME="public-alb"
TARGET_GROUP_NAME="instance-target-group"
RULE_PRIORITY=10
PATH_PATTERN="/*"

# 获取ALB ARN
ALB_ARN=$(aws elbv2 describe-load-balancers --names $ALB_NAME --query 'LoadBalancers[0].LoadBalancerArn' --output text)
echo "ALB ARN: $ALB_ARN"

# 获取目标组ARN
TG_ARN=$(aws elbv2 describe-target-groups --names $TARGET_GROUP_NAME --query 'TargetGroups[0].TargetGroupArn' --output text)
echo "Target Group ARN: $TG_ARN"

# 获取监听器ARN（假设第一个监听器）
LISTENER_ARN=$(aws elbv2 describe-listeners --load-balancer-arn $ALB_ARN --query 'Listeners[0].ListenerArn' --output text)
echo "Listener ARN: $LISTENER_ARN"

# 检查监听器类型和端口
LISTENER_PROTOCOL=$(aws elbv2 describe-listeners --listener-arns $LISTENER_ARN --query 'Listeners[0].Protocol' --output text)
LISTENER_PORT=$(aws elbv2 describe-listeners --listener-arns $LISTENER_ARN --query 'Listeners[0].Port' --output text)
echo "Listener Protocol: $LISTENER_PROTOCOL, Port: $LISTENER_PORT"

# 添加转发规则
echo "Adding forwarding rule to existing listener..."
aws elbv2 create-rule \
    --listener-arn $LISTENER_ARN \
    --priority $RULE_PRIORITY \
    --conditions Field=path-pattern,Values="$PATH_PATTERN" \
    --actions Type=forward,TargetGroupArn=$TG_ARN

echo "✅ Rule added successfully. Target group is now associated with the ALB listener."
~                                                                                                                                 
~                                                                                                                                 
~                                                                                                                                 
~                                                               