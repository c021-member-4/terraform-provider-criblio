resource "criblio_monitor" "demo" {
  id      = "tf-demo-monitor"
  name    = "Terraform Demo Monitor"
  enabled = true
  type    = "threshold"

  # Dataset the monitor evaluates against; set to the dataset name your workspace uses.
  dataset_id = "metrics"

  priority = jsonencode({ value = "P2" })
  team     = jsonencode({ value = "ops" })

  # Query keyed by label "A". In a real monitor include datasetId per-query:
  # A = { mode = "promql", promql = "...", datasetId = "metrics" }
  query = jsonencode({
    A = { mode = "promql", promql = "up" }
  })

  expr = jsonencode([])

  firing_condition = jsonencode({
    fire_delay  = 300
    clear_delay = 60
  })

  firing_rule = jsonencode({
    label     = "down"
    threshold = [
      {
        severity     = "critical"
        limit        = 0
        operator     = "lt"
        includedTags = []
        excludedTags = []
      }
    ]
  })

  metadata     = jsonencode({})
  notification = jsonencode({ enabled = false, type = "policy", config = [] })
  silence      = ["sil_test_placeholder"]
}

data "criblio_monitor" "demo" {
  id         = criblio_monitor.demo.id
  depends_on = [criblio_monitor.demo]
}

output "monitor_id" {
  value = criblio_monitor.demo.id
}

output "monitor_managed_by" {
  description = "Stamped to 'terraform' by the backend when speakeasy-sdk/terraform User-Agent is detected."
  value       = data.criblio_monitor.demo.managed_by
}

output "monitor_dataset_id" {
  description = "Dataset the monitor queries against."
  value       = data.criblio_monitor.demo.dataset_id
}
