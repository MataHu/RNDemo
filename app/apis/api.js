import DevicesInfo from 'react-native-device-info';

function api (methodType, url, map) {
  const headers = {}
  if (headers["Accept"] == undefined) {
    headers["Accept"] = "application/json";
  }
  if (headers["Content-Type"] == undefined) {
    headers["Content-Type"] = "application/json";
  }

  console.log("request map:" + JSON.stringify(map));  
  return fetch(url, {
    method: methodType,
    headers: headers,
    body: JSON.stringify(map)    
  }).then((response) => {
    return response.json()
  }).catch(() => {
  })
}

export const TKApi = (map) => api('POST', 'http://tk.word1k.com/goods/query', map)

export const SecKillApi = (map) => api('POST', 'http://tk.word1k.com/goods/query', map)