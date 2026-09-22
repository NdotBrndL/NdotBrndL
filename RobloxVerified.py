import json
import os
import time
import datetime
import typing
from urllib import request, parse, error


def printMainMessage(mes):
    print(f"\033[38;5;255m{mes}\033[0m")


def printErrorMessage(mes):
    print(f"\033[38;5;196m{mes}\033[0m")


def printSuccessMessage(mes):
    print(f"\033[38;5;82m{mes}\033[0m")


def printWarnMessage(mes):
    print(f"\033[38;5;202m{mes}\033[0m")


def printYellowMessage(mes):
    print(f"\033[38;5;226m{mes}\033[0m")


def printDebugMessage(mes):
    print(f"\033[38;5;226m{mes}\033[0m")


def isYes(text):
    return text.lower() in {"y", "yes"}


def isNo(text):
    return text.lower() in {"n", "no"}


def isRequestClose(text):
    return text.lower() in {"exit", "exit()"}


class Response:
    def __init__(self, status_code: int = 0, text: str = "", headers: typing.Optional[dict] = None, url: str = ""):
        self.status_code = status_code
        self.text = text
        self.headers = headers or {}
        self.url = url
        self._json = None

    @property
    def ok(self):
        return 200 <= self.status_code < 300

    @property
    def json(self):
        if self._json is not None:
            return self._json
        if not self.text:
            self._json = None
            return None
        try:
            self._json = json.loads(self.text)
        except Exception:
            self._json = None
        return self._json


class HttpClient:
    def __init__(self, timeout: float = 30.0):
        self.timeout = timeout

    def get(self, url: str, headers: typing.Optional[dict] = None, cookies: typing.Optional[typing.Union[dict, str]] = None, auth: typing.Optional[list] = None, timeout: typing.Optional[float] = None):
        return self._request("GET", url, None, headers=headers, cookies=cookies, auth=auth, timeout=timeout)

    def post(self, url: str, data: typing.Any, headers: typing.Optional[dict] = None, cookies: typing.Optional[typing.Union[dict, str]] = None, auth: typing.Optional[list] = None, timeout: typing.Optional[float] = None):
        return self._request("POST", url, data, headers=headers, cookies=cookies, auth=auth, timeout=timeout)

    def patch(self, url: str, data: typing.Any, headers: typing.Optional[dict] = None, cookies: typing.Optional[typing.Union[dict, str]] = None, auth: typing.Optional[list] = None, timeout: typing.Optional[float] = None):
        return self._request("PATCH", url, data, headers=headers, cookies=cookies, auth=auth, timeout=timeout)

    def put(self, url: str, data: typing.Any, headers: typing.Optional[dict] = None, cookies: typing.Optional[typing.Union[dict, str]] = None, auth: typing.Optional[list] = None, timeout: typing.Optional[float] = None):
        return self._request("PUT", url, data, headers=headers, cookies=cookies, auth=auth, timeout=timeout)

    def delete(self, url: str, headers: typing.Optional[dict] = None, cookies: typing.Optional[typing.Union[dict, str]] = None, auth: typing.Optional[list] = None, timeout: typing.Optional[float] = None):
        return self._request("DELETE", url, None, headers=headers, cookies=cookies, auth=auth, timeout=timeout)

    def head(self, url: str, headers: typing.Optional[dict] = None, cookies: typing.Optional[typing.Union[dict, str]] = None, auth: typing.Optional[list] = None, timeout: typing.Optional[float] = None):
        return self._request("HEAD", url, None, headers=headers, cookies=cookies, auth=auth, timeout=timeout)

    def _request(self, method: str, url: str, data: typing.Any, headers: typing.Optional[dict] = None, cookies: typing.Optional[typing.Union[dict, str]] = None, auth: typing.Optional[list] = None, timeout: typing.Optional[float] = None):
        timeout_value = timeout if timeout is not None else self.timeout
        final_headers = dict(headers or {})

        if cookies:
            if isinstance(cookies, dict):
                cookie_header = "; ".join(f"{k}={v}" for k, v in cookies.items())
                final_headers["Cookie"] = cookie_header
            elif isinstance(cookies, str):
                final_headers["Cookie"] = cookies

        if auth and len(auth) == 2:
            up = f"{auth[0]}:{auth[1]}".encode("utf-8")
            final_headers["Authorization"] = "Basic " + __import__("base64").b64encode(up).decode("utf-8")

        body = None
        if data is not None:
            if isinstance(data, (dict, list)):
                body = json.dumps(data).encode("utf-8")
                final_headers.setdefault("Content-Type", "application/json")
            else:
                body = str(data).encode("utf-8")

        request_obj = request.Request(url, data=body, headers=final_headers, method=method)
        try:
            with request.urlopen(request_obj, timeout=timeout_value) as resp:
                raw = resp.read().decode("utf-8", errors="replace")
                return Response(status_code=resp.getcode(), text=raw, headers=dict(resp.headers.items()), url=url)
        except error.HTTPError as exc:
            raw = exc.read().decode("utf-8", errors="replace")
            return Response(status_code=exc.code, text=raw, headers=dict(exc.headers.items()), url=url)
        except Exception:
            raise


class pip:
    """Lightweight compatibility class so the script can still instantiate pip()."""

    def __init__(self, *args, **kwargs):
        self.debug = kwargs.get("debug", False)
        self.executable = kwargs.get("executable")

    def printDebugMessage(self, message: str):
        if self.debug:
            print(f"\033[38;5;226m[PyKits] [DEBUG]: {message}\033[0m")


printWarnMessage("--- Preparing Regeneration ---")
current_path_location = os.path.dirname(os.path.abspath(__file__))
approved_users_path = os.path.join(current_path_location, "approved_users.json")
requests = HttpClient(timeout=30)

try:
    with open(approved_users_path, "r", encoding="utf-8") as f:
        approved = json.load(f)
    printMainMessage("Loaded Currently Approved Users.")
    printMainMessage(f"Approved Users Path: {approved_users_path}")
except Exception:
    printErrorMessage("Uh oh! There was an error trying to read your approved users JSON file!")
    raise SystemExit(1)

try:
    generated_filtered_json = {}
    for user_id in sorted(approved.keys()):
        printWarnMessage(f"--- User ID: {user_id} ---")
        try:
            start_time = datetime.datetime.now(datetime.timezone.utc).timestamp()

            def user_data_scan():
                for _ in range(10):
                    res = requests.get(f"https://users.roblox.com/v1/users/{user_id}")
                    if res.ok:
                        data = res.json
                        if isinstance(data, dict) and data.get("name"):
                            return data
                    time.sleep(1)
                return {}

            def scan_groups():
                for _ in range(10):
                    res = requests.get(
                        f"https://groups.roblox.com/v1/users/{user_id}/groups/roles?includeLocked=true&includeNotificationPreferences=true"
                    )
                    if res.ok:
                        payload = res.json
                        if isinstance(payload, dict):
                            return payload.get("data", [])
                    if res.status_code == 429:
                        time.sleep(1)
                        continue
                    return []
                return []

            user_data = user_data_scan()
            groups = scan_groups()
            owned_group_names = []
            approved_groups = []

            for group_entry in groups:
                group = group_entry.get("group") if isinstance(group_entry, dict) else None
                if not group:
                    continue
                owner = group.get("owner") if isinstance(group, dict) else None
                if isinstance(owner, dict) and str(owner.get("userId")) == str(user_id):
                    approved_groups.append(group)
                    owned_group_names.append(group.get("name", "Unknown Group"))

            generated_filtered_json[str(user_id)] = {
                "name": user_data.get("name"),
                "id": user_data.get("id"),
                "displayName": user_data.get("displayName"),
                "hexColor": approved.get(str(user_id), {}).get("hexColor") or "#0066ff",
                "approve_groups": approved_groups,
                "scan_timestamp": int(datetime.datetime.now(datetime.timezone.utc).timestamp()),
                "scan_duration": round(datetime.datetime.now(datetime.timezone.utc).timestamp() - start_time, 2),
            }

            printMainMessage(f"Name: {generated_filtered_json[str(user_id)]['displayName']} [@{generated_filtered_json[str(user_id)]['name']}]")
            printMainMessage(f"User ID: {generated_filtered_json[str(user_id)]['id']}")
            printMainMessage(f"Groups: {', '.join(owned_group_names) if owned_group_names else 'None'}")
            printMainMessage(f"Color: {generated_filtered_json[str(user_id)]['hexColor']}")
            printMainMessage(f"Scan Duration: {generated_filtered_json[str(user_id)]['scan_duration']}s")
        except Exception as exc:
            printErrorMessage(f"Unable to scan ID: {user_id} | Error: {str(exc)}")

    printWarnMessage("--- Finishing up ---")
    printMainMessage("Finalizing Save..")
    with open(approved_users_path, "w", encoding="utf-8") as f:
        json.dump(generated_filtered_json, f, indent=4)

    printSuccessMessage(f"Successfully generated an approved users JSON file containing {len(generated_filtered_json.keys())} users!")
    printSuccessMessage(f"File Location: {approved_users_path}")
    printSuccessMessage("In order to use this JSON file, install Efaz's Roblox Verified Badge Add-on from the Chrome Webstore and then set this as the Approved JSON.")
except Exception as exc:
    printErrorMessage("Uh oh! There was an error generating an approved users JSON file!")
    printErrorMessage(f"Exception: {str(exc)}")

input("> ")
