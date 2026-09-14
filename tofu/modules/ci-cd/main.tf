# ---------------------------------------------------------------------------------------------------------------------
# GITHUB OIDC PROVIDER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  url             = var.github_oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.github_oidc_thumbprints
}

# ---------------------------------------------------------------------------------------------------------------------
# PLAN IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "plan" {
  name               = var.plan_role_name
  assume_role_policy = data.aws_iam_policy_document.plan_trust.json
}

data "aws_iam_policy_document" "plan_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Allow this role to be used on any branch / PR in the specified repo
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${local.github_owner}/${local.github_repo}:ref:refs/heads/*",
        "repo:${local.github_owner}/${local.github_repo}:pull_request",
      ]
    }
  }
}

data "aws_iam_policy_document" "plan" {
  statement {
    effect = "Allow"
    actions = [
      "acm:Describe*",
      "acm:Get*",
      "acm:List*",
      "autoscaling:Describe*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "ec2:Describe*",
      "ec2:Get*",
      "elasticloadbalancing:Describe*",
      "iam:Get*",
      "iam:List*",
      "managed-fleets:Get*",
      "route53:Get*",
      "route53:List*",
      "s3:Get*",
      "s3:List*",
      "sns:Get*",
      "ssm:Get*",
      "sts:GetCallerIdentity",
      "vpc-lattice:Describe*",

      # This is necessary when running 'plan' with a state file in S3. This permission should be limited to just the
      # S3 bucket used for state
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "plan" {
  name   = "plan"
  role   = aws_iam_role.plan.id
  policy = data.aws_iam_policy_document.plan.json
}

# ---------------------------------------------------------------------------------------------------------------------
# APPLY IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "apply" {
  name               = var.apply_role_name
  assume_role_policy = data.aws_iam_policy_document.apply_trust.json
}

data "aws_iam_policy_document" "apply_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Only allow this role to be used on the main branch in the specified repo
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.github_owner}/${local.github_repo}:ref:refs/heads/main"]
    }
  }
}

data "aws_iam_policy_document" "apply" {
  statement {
    effect = "Allow"
    actions = [
      "acm:*",
      "autoscaling:*",
      "cloudwatch:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "managed-fleets:*",
      "route53:*",
      "s3:*",
      "sns:*",
      "ssm:Get*",
      "sts:GetCallerIdentity",
      "vpc-lattice:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:AttachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:CreateRole",
      "iam:DeleteInstanceProfile",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:Get*",
      "iam:List*",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:UpdateAssumeRolePolicy",
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "apply" {
  name   = "apply"
  role   = aws_iam_role.apply.id
  policy = data.aws_iam_policy_document.apply.json
}

locals {
  # GitHub requires immutable IDs in subject claims for all repos created after July 15, 2026
  # https://github.blog/changelog/2026-04-23-immutable-subject-claims-for-github-actions-oidc-tokens/
  github_owner = var.github_owner_id == null ? var.github_owner : "${var.github_owner}@${var.github_owner_id}"
  github_repo  = var.github_repo_id == null ? var.github_repo : "${var.github_repo}@${var.github_repo_id}"
}