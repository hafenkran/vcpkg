# Automatically generated by generateFeatures.ps1
if("access-management" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY access-management)
endif()
if("acm" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY acm)
endif()
if("alexaforbusiness" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY alexaforbusiness)
endif()
if("apigateway" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY apigateway)
endif()
if("application-autoscaling" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY application-autoscaling)
endif()
if("appstream" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY appstream)
endif()
if("appsync" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY appsync)
endif()
if("athena" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY athena)
endif()
if("autoscaling" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY autoscaling)
endif()
if("autoscaling-plans" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY autoscaling-plans)
endif()
if("AWSMigrationHub" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY AWSMigrationHub)
endif()
if("batch" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY batch)
endif()
if("budgets" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY budgets)
endif()
if("ce" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY ce)
endif()
if("cloud9" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloud9)
endif()
if("clouddirectory" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY clouddirectory)
endif()
if("cloudformation" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloudformation)
endif()
if("cloudfront" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloudfront)
endif()
if("cloudhsm" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloudhsm)
endif()
if("cloudhsmv2" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloudhsmv2)
endif()
if("cloudsearch" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloudsearch)
endif()
if("cloudsearchdomain" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloudsearchdomain)
endif()
if("cloudtrail" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cloudtrail)
endif()
if("codebuild" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY codebuild)
endif()
if("codecommit" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY codecommit)
endif()
if("codedeploy" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY codedeploy)
endif()
if("codepipeline" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY codepipeline)
endif()
if("codestar" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY codestar)
endif()
if("cognito-identity" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cognito-identity)
endif()
if("cognito-idp" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cognito-idp)
endif()
if("cognito-sync" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cognito-sync)
endif()
if("comprehend" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY comprehend)
endif()
if("config" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY config)
endif()
if("cur" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY cur)
endif()
if("datapipeline" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY datapipeline)
endif()
if("dax" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY dax)
endif()
if("devicefarm" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY devicefarm)
endif()
if("directconnect" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY directconnect)
endif()
if("discovery" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY discovery)
endif()
if("dms" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY dms)
endif()
if("ds" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY ds)
endif()
if("dynamodb" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY dynamodb)
endif()
if("dynamodbstreams" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY dynamodbstreams)
endif()
if("ec2" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY ec2)
endif()
if("ecr" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY ecr)
endif()
if("ecs" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY ecs)
endif()
if("elasticache" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY elasticache)
endif()
if("elasticbeanstalk" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY elasticbeanstalk)
endif()
if("elasticfilesystem" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY elasticfilesystem)
endif()
if("elasticloadbalancing" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY elasticloadbalancing)
endif()
if("elasticloadbalancingv2" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY elasticloadbalancingv2)
endif()
if("elasticmapreduce" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY elasticmapreduce)
endif()
if("elastictranscoder" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY elastictranscoder)
endif()
if("email" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY email)
endif()
if("es" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY es)
endif()
if("events" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY events)
endif()
if("firehose" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY firehose)
endif()
if("gamelift" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY gamelift)
endif()
if("glacier" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY glacier)
endif()
if("glue" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY glue)
endif()
if("greengrass" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY greengrass)
endif()
if("guardduty" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY guardduty)
endif()
if("health" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY health)
endif()
if("iam" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY iam)
endif()
if("identity-management" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY identity-management)
endif()
if("importexport" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY importexport)
endif()
if("inspector" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY inspector)
endif()
if("iot" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY iot)
endif()
if("iot-data" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY iot-data)
endif()
if("iot-jobs-data" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY iot-jobs-data)
endif()
if("kinesis" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY kinesis)
endif()
if("kinesis-video-archived-media" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY kinesis-video-archived-media)
endif()
if("kinesis-video-media" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY kinesis-video-media)
endif()
if("kinesisanalytics" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY kinesisanalytics)
endif()
if("kinesisvideo" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY kinesisvideo)
endif()
if("kms" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY kms)
endif()
if("lambda" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY lambda)
endif()
if("lex" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY lex)
endif()
if("lex-models" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY lex-models)
endif()
if("lightsail" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY lightsail)
endif()
if("logs" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY logs)
endif()
if("machinelearning" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY machinelearning)
endif()
if("marketplace-entitlement" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY marketplace-entitlement)
endif()
if("marketplacecommerceanalytics" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY marketplacecommerceanalytics)
endif()
if("mediaconvert" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mediaconvert)
endif()
if("medialive" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY medialive)
endif()
if("mediapackage" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mediapackage)
endif()
if("mediastore" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mediastore)
endif()
if("mediastore-data" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mediastore-data)
endif()
if("meteringmarketplace" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY meteringmarketplace)
endif()
if("mobile" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mobile)
endif()
if("mobileanalytics" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mobileanalytics)
endif()
if("monitoring" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY monitoring)
endif()
if("mq" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mq)
endif()
if("mturk-requester" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY mturk-requester)
endif()
if("opsworks" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY opsworks)
endif()
if("opsworkscm" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY opsworkscm)
endif()
if("organizations" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY organizations)
endif()
if("pinpoint" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY pinpoint)
endif()
if("polly" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY polly)
endif()
if("polly-sample" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY polly-sample)
endif()
if("pricing" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY pricing)
endif()
if("queues" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY queues)
endif()
if("rds" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY rds)
endif()
if("redshift" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY redshift)
endif()
if("rekognition" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY rekognition)
endif()
if("resource-groups" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY resource-groups)
endif()
if("resourcegroupstaggingapi" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY resourcegroupstaggingapi)
endif()
if("route53" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY route53)
endif()
if("route53domains" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY route53domains)
endif()
if("s3" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY s3)
endif()
if("s3-encryption" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY s3-encryption)
endif()
if("sagemaker" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY sagemaker)
endif()
if("sagemaker-runtime" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY sagemaker-runtime)
endif()
if("sdb" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY sdb)
endif()
if("serverlessrepo" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY serverlessrepo)
endif()
if("servicecatalog" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY servicecatalog)
endif()
if("servicediscovery" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY servicediscovery)
endif()
if("shield" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY shield)
endif()
if("sms" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY sms)
endif()
if("snowball" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY snowball)
endif()
if("sns" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY sns)
endif()
if("sqs" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY sqs)
endif()
if("ssm" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY ssm)
endif()
if("states" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY states)
endif()
if("storagegateway" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY storagegateway)
endif()
if("sts" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY sts)
endif()
if("support" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY support)
endif()
if("swf" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY swf)
endif()
if("text-to-speech" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY text-to-speech)
endif()
if("transcribe" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY transcribe)
endif()
if("transfer" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY transfer)
endif()
if("translate" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY translate)
endif()
if("waf" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY waf)
endif()
if("waf-regional" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY waf-regional)
endif()
if("workdocs" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY workdocs)
endif()
if("workmail" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY workmail)
endif()
if("workspaces" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY workspaces)
endif()
if("xray" IN_LIST FEATURES)
  list(APPEND BUILD_ONLY xray)
endif()
