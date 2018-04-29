variable "aws_region" {
  type = "string"
  default = "us-east-1"
}

variable "aws_access_key"{
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "github_org_name" {
  type = "string"
}

variable "github_repo_name" {
  type = "string"
}


# Specify the provider and access details
provider "aws" {
  version = "~> 1.16"
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_s3_bucket" "foo" {
  bucket = "test-bucket-20180429-foo"
  acl    = "private"
  force_destroy = true
}


resource "aws_iam_role" "foo" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
#  role = "${aws_iam_role.codepipeline_role.id}"
  role = "${aws_iam_role.foo.id}"
  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::codepipeline*",
                "arn:aws:s3:::elasticbeanstalk*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision",
                "codebuild:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:CreateApplicationVersion",
                "elasticbeanstalk:DescribeApplicationVersions",
                "elasticbeanstalk:DescribeEnvironments",
                "elasticbeanstalk:DescribeEvents",
                "elasticbeanstalk:UpdateEnvironment",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:ResumeProcesses",
                "autoscaling:SuspendProcesses",
                "cloudformation:GetTemplate",
                "cloudformation:DescribeStackResource",
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "ec2:DescribeInstances",
                "ec2:DescribeImages",
                "ec2:DescribeAddresses",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeKeyPairs",
                "elasticloadbalancing:DescribeLoadBalancers",
                "rds:DescribeDBInstances",
                "rds:DescribeOrderableDBInstanceOptions",
                "sns:ListSubscriptionsByTopic"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:invokefunction",
                "lambda:listfunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketPolicy",
                "s3:GetObjectAcl",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::elasticbeanstalk*",
            "Effect": "Allow"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

/*
data "aws_kms_alias" "s3kmskey" {
  name = "alias/myKmsKey"
}
*/

resource "aws_codepipeline" "foo" {
  name     = "tf-test-pipeline"
  role_arn = "${aws_iam_role.foo.arn}"

  artifact_store {
    location = "${aws_s3_bucket.foo.bucket}"
    type     = "S3"
/*    encryption_key {
      id   = "${data.aws_kms_alias.s3kmskey.arn}"
      type = "KMS"
    } */
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["test"]

      configuration {
        PollForSourceChanges = "true"
        Owner      = "${var.github_org_name}"
        Repo       = "${var.github_repo_name}"
        Branch     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["test"]
      version         = "1"

      configuration {
        ProjectName = "test"
      }
    }
  }
}

