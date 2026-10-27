"""Verify the personal API using only Python's standard library."""
import argparse
import json
import logging
from pathlib import Path
import time
import urllib.error
import urllib.request


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--base-url', default='http://localhost:8080/api/ziyayev-olzhas')
    args = parser.parse_args()
    base = args.base_url.rstrip('/')
    evidence = Path(__file__).resolve().parent.parent / 'evidence'
    evidence.mkdir(exist_ok=True)
    logging.basicConfig(level=logging.INFO, format='%(message)s', handlers=[
        logging.StreamHandler(), logging.FileHandler(evidence / 'Ziyayev_Olzhas_api_python.txt', encoding='utf-8', mode='w')])
    # Requests target the explicitly supplied local API, independent of system proxies.
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
    logging.info('API verification: Ziyayev Olzhas | IT2-2302 | %s', base)
    for attempt in range(90):
        try:
            with opener.open(base, timeout=3) as response:
                if response.status == 200:
                    break
        except (urllib.error.URLError, TimeoutError):
            time.sleep(2)
    else:
        raise RuntimeError('Application did not become ready')

    def request(method, path, expected, body=None):
        data = json.dumps(body).encode() if body is not None else None
        req = urllib.request.Request(base + path, data=data, method=method,
                                     headers={'Content-Type': 'application/json'})
        try:
            response = opener.open(req, timeout=20)
        except urllib.error.HTTPError as error:
            response = error
        with response:
            content = response.read().decode()
            logging.info('%s %s -> HTTP %s (expected %s)', method, path or '/', response.status, expected)
            logging.info(content or '(empty body)')
            if response.status != expected:
                raise AssertionError(f'Expected HTTP {expected}, got {response.status}')
            return json.loads(content) if content else None

    identity = request('GET', '', 200)
    assert identity['student'] == 'Ziyayev Olzhas'
    assert identity['group'] == 'IT2-2302'
    body = {'fullName': 'Ziyayev Olzhas', 'groupName': 'IT2-2302', 'email': 'olzhas@example.com'}
    created = request('POST', '/students', 201, body)
    student_id = created['id']
    listed = request('GET', '/students', 200)
    assert any(student['id'] == student_id for student in listed)
    request('GET', f'/students/{student_id}', 200)
    body['fullName'] = 'Ziyayev Olzhas Updated'
    body['email'] = 'updated@example.com'
    updated = request('PUT', f'/students/{student_id}', 200, body)
    assert updated['fullName'] == body['fullName']
    fetched = request('GET', f'/students/{student_id}', 200)
    assert fetched['email'] == body['email']
    request('POST', '/students', 400, {'fullName': '', 'groupName': '', 'email': 'bad'})
    request('DELETE', f'/students/{student_id}', 204)
    request('GET', f'/students/{student_id}', 404)
    request('PUT', f'/students/{student_id}', 404, body)
    request('DELETE', f'/students/{student_id}', 404)
    logging.info('All API checks passed.')


if __name__ == '__main__':
    main()
