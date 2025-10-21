package main

import (
	"os"

	"fmt"

	log "github.com/sirupsen/logrus"
)

func main() {
	log.SetReportCaller(true)

	hostDevPluginConfig, err := loadConfig()

	if err != nil {
		log.Fatal(err)
		os.Exit(-1)
	}

	fmt.Printf("config: %#v\n", *hostDevPluginConfig)

	pluginManager, err := NewHostDevicePluginManager(hostDevPluginConfig)
	if err != nil {
		log.Fatal(err)
	}

	pluginManager.RegisterPluginToKubelet()

	if err := pluginManager.Start(); err != nil {
		log.Fatal(err)
	}
}
