//
// Copyright (c) 2020 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

@Library("edgex-global-pipelines@b2dc629956b20c8a69344c2b67dbc2640f7419d6") _

edgeXBuildDocker (
    project: 'edgex-golang-base',
    mavenSettings: 'ci-build-images-settings',
    dockerImageName: 'edgex-golang-base',
    dockerNamespace: 'edgex-devops',
    dockerNexusRepo: 'snapshots',
    dockerTags: ["1.16-alpine", "1.16-alpine3.13"],
    releaseBranchOverride: 'golang-1.16'
)