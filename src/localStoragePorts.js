module.exports = localStoragePortsFactory;

/**
 * Create a ports object.
 * From: https://github.com/paulstatezny/elm-phoenix-websocket-ports/
 *
 */
function localStoragePortsFactory() {

  function register(ports, log) {
    ports.localStorageFromElm.subscribe(localStorageFromElm);

    log = log || function() {};

    function assertNever(x) {
      throw new Error('Unexpected object: ' + x);
    }

    // From: https://github.com/dillonkearns/elm-typescript-starter/blob/custom-types-spike
    function localStorageFromElm(data) {
      if (data.kind === 'StoreItem') {
        log('StoreItem!', data);
        localStorage.setItem(data.key, JSON.stringify(data.item));
      } else if (data.kind === 'ClearItem') {
        log('ClearItem!', data);
        localStorage.removeItem(data.key);
      } else if (data.kind === 'LoadItem') {
        log('LoadItem!', data);
        const getItemString = localStorage.getItem(data.key);
        if (getItemString) {
          ports.localStorageToElm.send({
            kind: 'LoadedItem',
            key: data.key,
            item: JSON.parse(getItemString)
          });
        }
      } else {
        assertNever(data);
      }
    }
  }

  return {
    register: register,
    samplePortName: 'localStorageFromElm'
  };
}
