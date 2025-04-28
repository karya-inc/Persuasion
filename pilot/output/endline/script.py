import json
from typing import Dict, Any
import pandas as pd


def parse_line(line: str, worker_id:str) -> Dict[str, Any]:
    data_dict = {"worker_id": worker_id}
    try:
        line = line.replace('""', '"').strip()[1:-1]
        if not line:
            return data_dict

        components = json.loads(line)
        daily_activity_pairs = []
        last_activity = None

        for component in components:
            if component.get('ctype') == 'USER':
                dtype = component.get('dtype')
                if dtype == 'MCQ':
                    key = component.get('selected').get('key')
                    value = component.get('selected').get('value')
                    if(key == 'expensive_purchase_m'):
                        key = 'market_permission_m'

                    if key == 'daily_activity':
                        if last_activity:
                            daily_activity_pairs.append({
                                "daily_activity": last_activity,
                                "activity_time": value
                            })
                            last_activity = None
                        else:
                            last_activity = value
                    else:
                        data_dict[key] = value

                elif dtype == 'TEXT':
                    key = component.get('text').get('key')
                    value = component.get('text').get('value')
                    data_dict[key] = value

                elif dtype == 'FILL_BLANK':
                    key = component.get('output').get('key')
                    value = component.get('output').get('value')
                    if key == 'activity_time' and last_activity:
                        daily_activity_pairs.append({
                            "daily_activity": last_activity,
                            "activity_time": value
                        })
                        last_activity = None
                    else:
                        data_dict[key] = value

        if daily_activity_pairs:
            data_dict['daily_activity'] = daily_activity_pairs

    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")

    return data_dict


def read_file(file_path: str) -> list[Dict[str, Any]]:
    all_data = []
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()[1:]

        for line in lines:
            worker_id, line = line.split('$')
            data_dict = parse_line(line, worker_id)
            if data_dict:
                all_data.append(data_dict)

    except Exception as e:
        print(f"Error reading file: {e}")

    return all_data


if __name__ == "__main__":
    data = read_file('endline.csv')
    df = pd.DataFrame(data)
    print(df.head())
    df.to_csv('output.csv', index=False)
