let horizonColor = new THREE.Color(0xffffff);

let scene = getScene(horizonColor);
let camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.z = 5;

let renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

let hemiLight = getHemisphereLight();
let hemiLightHelper = new THREE.HemisphereLightHelper(hemiLight, 10);
scene.add(hemiLight);
scene.add(hemiLightHelper);

let dirLight = getDirectionalLight();
let dirLightHelper = new THREE.DirectionalLightHelper(dirLight);
scene.add(dirLight);
scene.add(dirLightHelper);

let sky = getSky(hemiLight.color, horizonColor);
scene.add(sky);

let ground = getGround();
scene.add(ground);

cube = getCube();
scene.add(cube);

let animate = function() {
  requestAnimationFrame(animate);

  cube.rotation.y += 0.02;

  renderer.render(scene, camera);
};

function getScene(horizonColor) {
  let scene = new THREE.Scene();
  scene.background = new THREE.Color().setHSL(0.6, 0, 1);
  scene.fog = new THREE.Fog(scene.background, 1, 5000);
  scene.fog.color.copy(horizonColor);
  return scene;
}

function getHemisphereLight() {
  let light = new THREE.HemisphereLight(0xffffff, 0xffffff, 0.6);
  light.color.setHSL(0.6, 1, 0.6);
  light.groundColor.setHSL(0.095, 1, 0.75);
  light.position.set(0, 50, 0);
  return light;
}

function getDirectionalLight() {
  let light = new THREE.DirectionalLight(0xffffff);
  light.color.setHSL(0.1, 1, 0.95);
  light.position.set(-1, 1.75, 1);
  light.position.multiplyScalar(30);
  light.castShadow = true;
  light.shadow.mapSize.width = 2048;
  light.shadow.mapSize.height = 2048;

  let d = 50;
  light.shadow.camera.left = -d;
  light.shadow.camera.right = d;
  light.shadow.camera.top = d;
  light.shadow.camera.bottom = -d;
  light.shadow.camera.far = 3500;
  light.shadow.bias = -0.0001;
  return light;
}

function getSky(skyColor, horizonColor) {
  let vertexShader = document.getElementById("vertexShader").textContent;
  let fragmentShader = document.getElementById("fragmentShader").textContent;
  let uniforms = {
    topColor: { value: new THREE.Color(0x0077ff) },
    bottomColor: { value: horizonColor },
    offset: { value: 33 },
    exponent: { value: 0.6 },
  };
  uniforms.topColor.value.copy(skyColor);
  let skyGeo = new THREE.SphereBufferGeometry(4000, 32, 15);
  let skyMat = new THREE.ShaderMaterial({
    vertexShader: vertexShader,
    fragmentShader: fragmentShader,
    uniforms: uniforms,
    side: THREE.BackSide,
  });
  return new THREE.Mesh(skyGeo, skyMat);
}

function getGround() {
  let groundGeo = new THREE.PlaneBufferGeometry(10000, 10000);
  let groundMat = new THREE.MeshPhongMaterial({ color: 0xffffff, specular: 0x050505 });
  groundMat.color.setHSL(0.095, 1, 0.75);
  let ground = new THREE.Mesh(groundGeo, groundMat);
  ground.rotation.x = -Math.PI / 2;
  ground.position.y = -33;
  ground.receiveShadow = true;
  return ground;
}

function getCube() {
  let geometry = new THREE.BoxGeometry(1, 1, 1);
  let material = new THREE.MeshBasicMaterial({ color: 0x993366 });
  return new THREE.Mesh(geometry, material);
}

animate();
