job "jalgoarena-auth" {
  datacenters = ["dc1"]

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "auth-docker" {
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    ephemeral_disk {
      size = 1000
    }

    task "jalgoarena-auth" {
      driver = "docker"

      config {
        image = "spolnik/jalgoarena-auth:2.2.115"
        network_mode = "host"
        volumes = ["/home/jacek/jalgoarena-config/UserDetailsStore:/app/UserDetailsStore"]
      }

      resources {
        cpu    = 750
        memory = 2000
      }
    }
  }
}