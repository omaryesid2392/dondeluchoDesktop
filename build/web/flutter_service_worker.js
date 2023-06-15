'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "d7bb8b86c2879171e419d26b7f1f606f",
"index.html": "e228b7d291a30bf9e532094b837010f6",
"/": "e228b7d291a30bf9e532094b837010f6",
"main.dart.js": "69fc563bba44536e08558481a9094870",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "d791d567d56b48b457552f789ad53625",
"assets/AssetManifest.json": "02ce7713303b046b2bc218dc280d9140",
"assets/NOTICES": "d854c241c113287bed5a8b8c341e6e89",
"assets/FontManifest.json": "4faf7b7d8e7ea3063af1b80b5c76da0b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "9cda082bd7cc5642096b56fa8db15b45",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "0a94bab8e306520dc6ae14c2573972ad",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b00363533ebe0bfdb95f3694d7647f6d",
"assets/packages/esc_pos_utils/resources/capabilities.json": "ae5c3288b81125ab9c54fff02d30387e",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/assets/new_service.mp3": "82c0d28bc1f8359f3dd21f02511c5d52",
"assets/assets/images/reparacion.png": "288fa887b87b001152d2bf6032c72fab",
"assets/assets/images/Celulares.png": "e018fffc3ff39f7ca30a05ab6a9efdf4",
"assets/assets/images/medicine_prevent.png": "35c54afb20dca480e2ccf633d6aa14a7",
"assets/assets/images/icon-app.png": "feae7c26e6204ccfca44d78497aab701",
"assets/assets/images/logo.png": "feae7c26e6204ccfca44d78497aab701",
"assets/assets/images/ob1.png": "e018fffc3ff39f7ca30a05ab6a9efdf4",
"assets/assets/images/logo_white.png": "f79f4eea43e48f423acccec7ddb6e27c",
"assets/assets/images/ob2.png": "ed7d51113ff1e9767452832e14730163",
"assets/assets/images/ob3.png": "36b3acca2c57c2d5079843132816ab11",
"assets/assets/images/logo_x2.png": "405257cd225a244e8f0d0d1413c46937",
"assets/assets/images/logo.svg": "e3f681c79b089c01a136c337f325c53d",
"assets/assets/images/accesorio.jpg": "8b9d6c16150106e4ee06ff0117ae1cb7",
"assets/assets/icons/07-medicine@3x.png": "cb8d4d1d14d2c44dc8c6146797f5e45f",
"assets/assets/icons/icon_doctor.png": "59abfa40e65c0718191418517257f939",
"assets/assets/icons/21-blood@3x.png": "d587799671038138a98b93f3ce10edbe",
"assets/assets/icons/thermometer.png": "6cc609f937b33b366718733de6877d22",
"assets/assets/icons/09-medical%2520history@3x.png": "4a492d595a3b82a967ee52060aed77b3",
"assets/assets/icons/15-drug@3x.png": "c189486862db9ca857bc10e8b40816c5",
"assets/assets/icons/02-document@3x.png": "dc3119a3c2e253c98e826336ac64bc29",
"assets/assets/icons/17-heart%2520rate@3x.png": "bac47d143462a7430abec19ee70df064",
"assets/assets/icons/24-doctor@3x.png": "86df04b1efb876aec2602fab3b66605a",
"assets/assets/icons/25-medical%2520history@3x.png": "3a024429525ee5febc6c71feb168843c",
"assets/assets/icons/29-syringe@3x.png": "331e48ab991d89a95a233d58d8f527b8",
"assets/assets/icons/medical-kit.png": "af5cc071470c260ee059f4c4491740d7",
"assets/assets/icons/18-pharmacy@3x.png": "30aef9e45fbe95785ce8d1d8f04f1659",
"assets/assets/icons/26-ambulance@3x.png": "2fa6925f9b1e46b201138574822d34e6",
"assets/assets/icons/smartphone.png": "3f51cc67e2c4b6597077c994d8b33ce1",
"assets/assets/icons/19-wash@3x.png": "e97390e8d4a6afd65411a7fb5360797c",
"assets/assets/icons/bed.png": "50fda81df450f397ddeacf42b394d41e",
"assets/assets/icons/28-medical%2520recorde@3x.png": "e8bc04b96874a3c8a6bce42a11141e4d",
"assets/assets/icons/icon_nurse.png": "efb26d265b9f8ee47bccf7bf35c49009",
"assets/assets/icons/hospital-4.png": "040b8cdd4f0140a3264e2625458786d1",
"assets/assets/icons/16-wheelchair@3x.png": "d3400d82bc8bd0087d699cf16965a475",
"assets/assets/icons/folder.png": "929d748adf7b26970ddb8405e5081d69",
"assets/assets/icons/10-invoice@3x.png": "f1c333194616edd8fcf4e93837185502",
"assets/assets/icons/nurse.png": "ffcd1fb3311fbeb3d0664b641fefc73d",
"assets/assets/icons/27-medical%2520history@3x.png": "4afa6d127fdd4aefa70c3c30e93637b3",
"assets/assets/icons/hospital-2.png": "38de84798b46b16808db55498b7796c2",
"assets/assets/icons/20-pharmacy@3x.png": "c189ad41163f8f23ba968241562358ee",
"assets/assets/icons/30-heart%2520rate@3x.png": "e4b59ecafc5459d43ef2bb22a6fea88b",
"assets/assets/icons/13-first%2520aid%2520kit@3x.png": "aca7235f6d84c738ef63762a92dfa30c",
"assets/assets/icons/wait_service.png": "c0a86fc2420f102f49b05efa65769b42",
"assets/assets/icons/23-report@3x.png": "3be42e8cff3caf775e563ad4650dc0de",
"assets/assets/icons/12-drug@3x.png": "ba556b6a77eda939be2cfeed80b666f0",
"assets/assets/icons/03-medical%2520history@3x.png": "c424cc2ae08bedea04519f5cad65598f",
"assets/assets/icons/22-pills@3x.png": "146ec51e2a2916614c76dcbfeefd867f",
"assets/assets/icons/strip.png": "3ba1df6af7f9fc6c9bbcc6e2d69886ab",
"assets/assets/icons/04-medical%2520result@3x.png": "b55b2fef9acd757b85b6c94c5127a5cb",
"assets/assets/icons/08-doctor@3x.png": "fcc9a3164d83e05513995ccda83ecdfd",
"assets/assets/icons/14-pharmacy@3x.png": "6eff621ccf6044f435c1bac8d58d331e",
"assets/assets/icons/05-hostpital@3x.png": "eb5ffd75d2499bee183a48e113a6a37b",
"assets/assets/icons/11-surgeon@3x.png": "63fd8e4bcaaebdf1f702cbf12980ef27",
"assets/assets/icon/icon-app2.png": "ca07c5616fdc7e92c5d31ba1a6374360",
"assets/assets/icon/icon-app.png": "feae7c26e6204ccfca44d78497aab701",
"assets/assets/fonts/WorkSans-Regular.ttf": "30be604d29fd477c201fb1d6e668eaeb",
"assets/assets/fonts/Roboto-Medium.ttf": "58aef543c97bbaf6a9896e8484456d98",
"assets/assets/fonts/HelveticaRoundedLTStd-Bd.ttf": "547805b36241d80ddcfae78abd1d4fce",
"assets/assets/fonts/HelveticaLTStd-Bold.otf": "516c0073254e129d27a76d1460f52032",
"assets/assets/fonts/Roboto-Regular.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/assets/fonts/HelveticaLTStd-Light.otf": "09fbf0911aa25976c6a2d5c4e914be4a",
"assets/assets/fonts/WorkSans-Medium.ttf": "488b6f72b6183415e7a20aafa803a0c8",
"assets/assets/fonts/WorkSans-SemiBold.ttf": "6f8da6d25c25d58ef3ec1c8b7c0e69c3",
"assets/assets/fonts/HelveticaLTStd-Roman.otf": "b9eeadb0b03ab87cf641bcd2cde54062",
"assets/assets/fonts/Roboto-Bold.ttf": "e07df86cef2e721115583d61d1fb68a6",
"assets/assets/fonts/WorkSans-Bold.ttf": "1fed2d8028f8f5356cbecedb03427405"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
