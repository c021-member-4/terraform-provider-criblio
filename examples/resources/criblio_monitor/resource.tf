# $profileRef is intentionally unsupported: it is UI-only and has no Terraform-authoring use case.
resource "criblio_monitor" "my_monitor" {
  id         = "high-cpu-usage"
  name       = "High CPU usage"
  enabled    = true
  type       = "threshold"
  dataset_id = "metrics"

  priority = jsonencode({ value = "P2" })
  team     = jsonencode({ value = "platform" })

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

  firing_rule = jsonencode({
    label = "A"
    threshold = [
      {
        severity       = "critical"
        limit          = 90
        operator       = "gt"
        includedTags   = []
        excludedTags   = []
        timesTriggered = 1
      }
    ]
  })

  metadata     = jsonencode({})
  notification = jsonencode({ enabled = false, type = "policy", config = [] })
  silence      = []
}
