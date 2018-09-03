import './main.css';
import { Main } from './Main.elm';

var app = Main.embed(document.getElementById('root'));

import registerServiceWorker from './registerServiceWorker';
registerServiceWorker();

const phoenix = require('./phoenix');
const socketAddress = '/socket';
const options = { timeout: 1000, params: { token: 'myaccesstoken' } };

import phoenixChannelPortsFactory from './phoenixChannelPorts';
const webSocketPorts = phoenixChannelPortsFactory(phoenix, socketAddress, options);
webSocketPorts.register(app.ports, console.log);

import localStoragePortsFactory from './localStoragePorts';
var localStoragePorts = localStoragePortsFactory();
localStoragePorts.register(app.ports, console.log);

import googleAnalyticsPortFactory from './googleAnalyticsPorts';
var googleAnalyticsPorts = googleAnalyticsPortFactory();
googleAnalyticsPorts.register(app.ports, console.log);
