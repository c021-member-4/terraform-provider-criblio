resource "criblio_monitor" "demo" {
  id      = "tf-demo-monitor"
  name    = "Terraform Demo Monitor"
  enabled = true
  type    = "threshold"

  # Dataset the monitor evaluates against; set to the dataset name your workspace uses.
  dataset_id = "metrics"

  priority = { value = "P2" }
  team     = { value = "ops" }

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

  firing_rule = {
    label = "down"
    threshold = [
      {
        severity      = "critical"
        limit         = 0
        operator      = "lt"
        included_tags = []
        excluded_tags = []
      }
    ]
  }

  metadata     = jsonencode({})
  notification = jsonencode({ enabled = false, type = "policy", config = [] })
}

data "criblio_monitor" "demo" {
  id         = criblio_monitor.demo.id
  depends_on = [criblio_monitor.demo]
}

output "monitor_id" {
  value = criblio_monitor.demo.id
}

output "monitor_managed_by" {
  description = "Stamped 'terraform' by the backend when provisioned via the Terraform provider (cribl/cribl#43133)."
  value       = data.criblio_monitor.demo.managed_by
}

output "monitor_dataset_id" {
  description = "Dataset the monitor queries against."
  value       = data.criblio_monitor.demo.dataset_id
}
