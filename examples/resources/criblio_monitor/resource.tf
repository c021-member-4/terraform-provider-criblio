# $profileRef is intentionally unsupported: it is UI-only and has no Terraform-authoring use case.
# silence is intentionally unsupported: there is no criblio_silence resource to create the
# windows it references, so the field is excluded until one exists.
resource "criblio_monitor" "my_monitor" {
  id         = "high-cpu-usage"
  name       = "High CPU usage"
  enabled    = true
  type       = "threshold"
  dataset_id = "metrics"

  priority = { value = "P2" }
  team     = { value = "platform" }

  query = jsonencode({
    A = {
      mode      = "promql"
      datasetId = "metrics"
      promql    = "avg by (host) (cpu_usage_percent)"
    }
  })

  expr = jsonencode([])

  firing_condition = jsonencode({
    fire_delay  = 300
    clear_delay = 60
  })

  firing_rule = {
    label = "A"
    threshold = [
      {
        severity        = "critical"
        limit           = 90
        operator        = "gt"
        included_tags   = []
        excluded_tags   = []
        times_triggered = 1
      }
    ]
  }

  metadata     = jsonencode({})
  notification = jsonencode({ enabled = false, type = "policy", config = [] })
}
