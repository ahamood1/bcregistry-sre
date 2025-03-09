locals {
  combined_pam_bindings = concat(
    var.pam_bindings,
    var.env.pam_bindings
  )
}

locals {
  pam_bindings_map = {
    for idx, binding in local.combined_pam_bindings : "binding-${idx}" => {
      entitlement_requesters = binding.principals
      role_bindings = [
        {
          role        = binding.role_type == "custom" ? "projects/${var.parent_id}/roles/${binding.role}" : binding.role
          principals = binding.principals
        }
      ]
      entitlement_id              = "entitlement-${idx}"
      parent_type                 = "project"
      max_request_duration_hours  = 8
    }
  }
}

module "pam" {
  for_each = local.pam_bindings_map

  source  = "GoogleCloudPlatform/pam/google"
  version = "2.1.0"

  parent_id             = var.parent_id
  organization_id       = var.organization_id
  entitlement_requesters = each.value.entitlement_requesters
  role_bindings         = each.value.role_bindings
  entitlement_id        = each.value.entitlement_id
  parent_type           = each.value.parent_type
  max_request_duration_hours = each.value.max_request_duration_hours
  entitlement_approval_notification_recipients = ["user:bcregistry-sre@gov.bc.ca"]
  auto_approve_entitlement = true
}
