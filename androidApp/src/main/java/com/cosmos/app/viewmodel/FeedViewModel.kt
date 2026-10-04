package com.cosmos.app.viewmodel

import com.cosmos.app.config.RemoteConfigManager
import com.cosmos.app.data.Repository
import com.cosmos.app.sync.FirestoreSyncEngine

class FeedViewModel(
    repository: Repository = Repository(),
    syncEngine: FirestoreSyncEngine = FirestoreSyncEngine(),
    remoteConfigManager: RemoteConfigManager = RemoteConfigManager()
) : HomeViewModel(repository, syncEngine, remoteConfigManager)
