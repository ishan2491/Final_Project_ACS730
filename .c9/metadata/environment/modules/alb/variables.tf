{"filter":false,"title":"variables.tf","tooltip":"/modules/alb/variables.tf","undoManager":{"mark":2,"position":2,"stack":[[{"start":{"row":0,"column":0},"end":{"row":93,"column":0},"action":"insert","lines":["variable \"vpc_id\" {","  description = \"VPC ID where the ALB will be deployed\"","  type        = string","}","","variable \"public_subnets\" {","  description = \"List of public subnet IDs for the ALB\"","  type        = list(string)","}","","variable \"lb_name\" {","  description = \"Name for the ALB\"","  type        = string","  default     = \"my-alb\"","}","","variable \"lb_security_groups\" {","  description = \"Security groups to attach to the ALB\"","  type        = list(string)","  default     = []  # Pass in from root module","}","","variable \"environment\" {","  description = \"Environment name for tagging\"","  type        = string","  default     = \"Prod\"","}","","variable \"listener_port\" {","  description = \"Port on which the ALB listens\"","  type        = number","  default     = 80","}","","variable \"listener_protocol\" {","  description = \"Protocol for the ALB listener\"","  type        = string","  default     = \"HTTP\"","}","","variable \"target_group_name\" {","  description = \"Name for the target group\"","  type        = string","  default     = \"my-target-group\"","}","","variable \"target_group_port\" {","  description = \"Port on which the target group receives traffic\"","  type        = number","  default     = 80","}","","variable \"target_group_protocol\" {","  description = \"Protocol for the target group\"","  type        = string","  default     = \"HTTP\"","}","","variable \"target_type\" {","  description = \"Target type for the target group (instance or ip)\"","  type        = string","  default     = \"instance\"","}","","variable \"health_check_path\" {","  description = \"Health check path for the target group\"","  type        = string","  default     = \"/\"","}","","variable \"health_check_protocol\" {","  description = \"Protocol for health check\"","  type        = string","  default     = \"HTTP\"","}","","variable \"health_check_interval\" {","  description = \"Interval (in seconds) for health checks\"","  type        = number","  default     = 30","}","","variable \"healthy_threshold\" {","  description = \"Healthy threshold count\"","  type        = number","  default     = 3","}","","variable \"unhealthy_threshold\" {","  description = \"Unhealthy threshold count\"","  type        = number","  default     = 3","}",""],"id":1}],[{"start":{"row":93,"column":0},"end":{"row":94,"column":0},"action":"insert","lines":["",""],"id":2}],[{"start":{"row":94,"column":0},"end":{"row":99,"column":0},"action":"insert","lines":["variable \"create_security_group\" {","  description = \"Flag to create a new security group for the ALB\"","  type        = bool","  default     = true","}",""],"id":3}]]},"ace":{"folds":[],"scrolltop":0,"scrollleft":0,"selection":{"start":{"row":99,"column":0},"end":{"row":99,"column":0},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1744044650400,"hash":"41a30263ee40b4c7ccd9b3cea27e43d9ffd807cc"}