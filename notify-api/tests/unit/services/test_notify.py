# Copyright © 2019 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""The Unit Test for the Service."""
from notify_api.services.notify_service import NotifyService
from tests.factories.notification import NotificationFactory


def test_get_provider(session):  # pylint: disable=unused-argument
    """Assert the test can get provider."""
    for notification_data in list(NotificationFactory.RequestProviderData):
        service = NotifyService()
        result = service.get_provider(
            notification_data["data"]["notifyType"], notification_data["data"]["content"]["body"]
        )
        assert result is not None
        assert result == notification_data["provider"]
