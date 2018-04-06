# osgi-run-configs
Contains various OSGi run configurations

## Projects
* `rundir-osgi`: a minimal OSGi configuration, which can be used as a template for real projects
* `rundir-ogema-felix`: a run configuration for OGEMA, which includes the [FendoDB data logger](https://github.com/smartrplace/fendodb) and the [OGEMA widgets](https://github.com/ogema/ogema-widgets)

## Run
To run of the configurations, execute the provided start scripts (`start.sh` for Bash-compatible shells, or `start.bat` for a Windows shell), or import the projects into the Eclipse IDE and use one of the provided launch configurations.

## Parameters
* `-clean`: clean start (if not set, and the framework had been started before, then the saved instance will be restarted)
* `-security`: activate OSGi/OGEMA security
Hence a clean start with security enabled can be achieved by executing
```
./start.sh -clean -security
```

## Configuration
The folder `config` contains several configuration files:
* `config.properties`: set system properties and configure the Felix OSGi framework
* `config.xml`: defines which bundles to start (resolved via Maven by the [Maven resolver](https://github.com/smartrplace/maven-resolver) bundle)
* `loglevels.properties`: specify loglevels for the OGEMA logger (OGEMA specific)
* `ogema.policy`: defines a set of static policies to apply when started with security enabled (OGEMA specific)
* `ogema.roles`: defines an initial set of users in a clean start (OGEMA specific)
* `repos.properties`: define custom Maven repositories for the Maven resolver

In addition, bundle jars may be placed in the folder `init`; they will be started by the Maven resolver as well. The folder `ext` on the other hand contains jar-Files that will be placed on the system classpath (if they contain a package that shall be made available to bundles, add the package to the org.osgi.framework.system.packages.extra property in the config/config.properties file).
