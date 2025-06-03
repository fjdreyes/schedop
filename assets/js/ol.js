import { Map, View, Feature } from "ol";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
import { XYZ, Vector as VectorSource } from "ol/source";
import { Style, Stroke, Fill, Text } from "ol/style";
import { Circle } from "ol/geom";
import { fromLonLat } from "ol/proj";

const viewCenter = fromLonLat([121.066761, 14.654147]);
const viewZoom = 15.8;
const xyzSourceUrl = "https://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png";

const nodesSource = new VectorSource();

const nodesStyle = new Style({
  stroke: new Stroke({
    color: "rgb(255, 0, 0)",
  }),
  fill: new Fill({
    color: "rgba(255, 255, 0, 0.5)",
  }),
  text: new Text({
    stroke: new Stroke({
      color: "rgb(255, 255, 255)",
      width: 5,
    }),
    offsetY: 15,
  }),
});

const map = new Map({
  target: "map",
  view: new View({
    center: viewCenter,
    zoom: viewZoom,
  }),
  layers: [
    new TileLayer({
      source: new XYZ({
        url: xyzSourceUrl,
      }),
    }),
    new VectorLayer({
      source: nodesSource,
      style: function (feature) {
        nodesStyle.getText().setText(feature.get("name"));
        return nodesStyle;
      },
    }),
  ],
});

function createFeature(name, lon, lat) {
  return new Feature({
    name: name,
    geometry: new Circle(fromLonLat([lon, lat]), 15),
  });
}

function populateMap() {
  const mapElement = document.getElementById("map");
  if (!!mapElement) {
    const nodesElement = mapElement.dataset.nodes;
    if (!!nodesElement) {
      const nodes = JSON.parse(nodesElement);
      nodes.forEach((node) => {
        const feature = createFeature(node[0], node[1], node[2]);
        nodesSource.addFeature(feature);
      });
    }
  }
}

window.addEventListener("DOMContentLoaded", () => {
  populateMap();
});
