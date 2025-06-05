import { Map, View, Feature } from "ol";
import { Tile as TileLayer, Vector as VectorLayer } from "ol/layer";
import { XYZ, Vector as VectorSource } from "ol/source";
import { Style, Stroke, Fill, Text } from "ol/style";
import { Circle } from "ol/geom";
import { GeoJSON } from "ol/format";
import { fromLonLat } from "ol/proj";

const viewCenter = fromLonLat([121.066761, 14.654147]);
const viewZoom = 15.8;
const xyzSourceUrl = "https://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png";

const vectorSource = new VectorSource();
const format = new GeoJSON();

const nodesStyle = new Style({
  stroke: new Stroke({
    color: "rgb(255, 0, 0)",
    width: 2,
  }),
  fill: new Fill({
    color: "rgba(255, 255, 0, 0.5)",
  }),
  text: new Text({
    stroke: new Stroke({
      color: "rgb(255, 255, 255)",
      width: 5,
    }),
  }),
});

const pathsStyle = new Style({
  stroke: new Stroke({
    color: "rgb(255, 0, 255, 0.8)",
    width: 2,
  }),
  text: new Text({
    stroke: new Stroke({
      color: "rgb(255, 255, 255)",
      width: 5,
    }),
    maxAngle: 0.26179939,
    placement: "line",
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
      source: vectorSource,
      style: function (feature) {
        if (feature.getGeometry().getType() === "Circle") {
          nodesStyle.getText().setText(feature.get("name"));
          return nodesStyle;
        } else if (feature.getGeometry().getType() === "LineString") {
          const pathDuration = feature.getProperties()?.summary?.duration;
          if (!!pathDuration) {
            const pathMinutes = Math.floor(pathDuration / 60);
            const pathSeconds = `${pathMinutes % 60}`.padStart(2, "0");
            const pathText = `${pathMinutes}:${pathSeconds}`;
            pathsStyle.getText().setText(pathText);
          }
          return pathsStyle;
        }
        return null;
      },
    }),
  ],
});

function createFeature(name, lon, lat) {
  return new Feature({
    name: name,
    geometry: new Circle(fromLonLat([lon, lat]), 20),
  });
}

function populateNodes(nodesElement) {
  JSON.parse(nodesElement).forEach((node) => {
    vectorSource.addFeature(createFeature(node[0], node[1], node[2]));
  });
}

function populatePaths(pathsElement) {
  JSON.parse(pathsElement).forEach((path) => {
    const url = `/api/paths/geojson/${path[0][0]}/${path[0][1]}/${path[1][0]}/${path[1][1]}`;
    fetch(url)
      .then((response) => response.json())
      .then((data) => {
        vectorSource.addFeatures(
          format.readFeatures(data, {
            featureProjection: "EPSG:3857",
          }),
        );
      });
  });
}

function populateMap() {
  const mapElement = document.getElementById("map");
  if (!!mapElement) {
    const nodesElement = mapElement.dataset.nodes;
    if (!!nodesElement) {
      populateNodes(nodesElement);
    }

    const pathsElement = mapElement.dataset.paths;
    if (!!pathsElement) {
      populatePaths(pathsElement);
    }
  }
}

window.addEventListener("DOMContentLoaded", () => {
  populateMap();
});
