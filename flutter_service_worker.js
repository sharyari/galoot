'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"main.dart.js": "c51f5247a814e060b69a8012debf5103",
"assets/AssetManifest.json": "f12fb5b0fe32635c9ec75cc5764b47bf",
"assets/assets/images/nykatt1.png": "c4d81709cf9acd3eadc11c27be55ab50",
"assets/assets/images/nykatt2.png": "848d77d10d0e75357cab6fca6186bd3b",
"assets/assets/images/nykatt3.png": "a8cbfcbd4612f16680868d23a157c857",
"assets/assets/images/katt2.png": "4b154493921edffd5ba85a4514eedf2e",
"assets/assets/images/knob.png": "5e31d07bddd7a904927c326a622e2cd9",
"assets/assets/images/katt1.png": "002d530a99dc7f4a81030e565602f495",
"assets/assets/images/farfar.png": "223cb85e2c22dafb0f68edfd42259641",
"assets/assets/images/dognald.jpeg": "d9fc537dc8b51fbf3f87a91a42c6e8ce",
"assets/assets/images/kattfram3.png": "6180d720845655a6379a60a6bac82b40",
"assets/assets/images/katt3.png": "78957c3bd4a7655be56996c4afd2577c",
"assets/assets/images/kattbak2.png": "69d1971c4e5777ea7786cffd0012498e",
"assets/assets/images/kattfram2.png": "c8f77ae742e984b770ca3a5b28201539",
"assets/assets/images/kattfram1.png": "6180d720845655a6379a60a6bac82b40",
"assets/assets/images/kattbak3.png": "ad5b24b74cc3a839f0a23e71040d5926",
"assets/assets/images/kattbak1.png": "1c71524ea89c5c02d6649c689f49daeb",
"assets/assets/images/knob_bg.png": "9a7e00871cc98d7fbbeba730be0a1d57",
"assets/assets/images/farfarblink.png": "0d3c67dd7515a7247822633f29127a6a",
"assets/assets/images/vakthund.png": "9e11e1168719fdb2aad8062d55bd5a55",
"assets/assets/audio/arg_mjau.mp3": "03e081521a4fd8b26d111bdcba9e13aa",
"assets/assets/audio/default_mjau2.mp3": "465f6a19de9fdc3a1c579f7d74e2161e",
"assets/assets/audio/scary_bgm.wav": "cad779a06973d65653d3b22533d98bc0",
"assets/assets/audio/bg.mp3": "a5b1de632be987c5750e2bd1182f2100",
"assets/assets/audio/default_mjau.mp3": "f364c30317431a0329b513e1677faa5b",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/NOTICES": "8abb00705d064ac13b345161732b320a",
"flutter.js": "eb2682e33f25cd8f1fc59011497c35f8",
"index.html": "e0d12a7062cc2faaafd81f82e669a62f",
"/": "e0d12a7062cc2faaafd81f82e669a62f",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "615543e13a1cd7c06a01086a8e5a13da",
"manifest.json": "44765d2e68a0f6e9a679ba8d40e1d79a",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
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
