c.KubeSpawner.privileged = True

c.Spawner.environment.update(dict(
       NVIDIA_VISIBLE_DEVICES='all',
       NVIDIA_DRIVER_CAPABILITIES='compute,utility',
       NVIDIA_REQUIRE_CUDA='cuda>=8.0'))

c.KubeSpawner.extra_resource_limits = {'nvidia.com/gpu': '1'}
