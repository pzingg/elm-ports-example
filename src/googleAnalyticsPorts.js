module.exports = googleAnalyticsPortsFactory;

/**
 * Create a ports object.
 * From: https://github.com/paulstatezny/elm-phoenix-websocket-ports/
 *
 * You'd probably have some Google Analytics setup code here, something like
 * https://github.com/dillonkearns/mobster/blob/2ad66f514579a09a9679b75b6c1b2956e7879b46/typescript/analytics.ts#L23-L40
 *
 */
function googleAnalyticsPortsFactory() {

  function register(ports, log) {
    ports.googleAnalyticsFromElm.subscribe(googleAnalyticsFromElm);

    log = log || function() {};

    function assertNever(x) {
      throw new Error('Unexpected object: ' + x);
    }

    // From: https://github.com/dillonkearns/elm-typescript-starter/blob/custom-types-spike
    function googleAnalyticsFromElm(data) {
      if (data.kind === 'TrackPage') {
        log('TrackPage!', data);

        // ... some Google Analytics track page code here,
        // could look something like
        // https://github.com/dillonkearns/mobster/blob/2ad66f514579a09a9679b75b6c1b2956e7879b46/typescript/analytics.ts#L46-L48
        if (window.ga) {
          window.ga('send', 'pageview', data.path);
        }
      } else if (data.kind === 'TrackEvent') {
        log('TrackEvent!', data);

        // ... some Google Analytics track event code here,
        // could look something like
        // https://github.com/dillonkearns/mobster/blob/2ad66f514579a09a9679b75b6c1b2956e7879b46/typescript/analytics.ts#L50-L53
        if (window.ga) {
            var gaobj = {
                hitType: 'event',
                eventCategory: data.category,
                eventAction: data.action
            };
            if (data.label) {
                gaobj.eventLabel = data.label;
            }
            if (event.value) {
                data.eventValue = data.value;
            }
            window.ga('send', gaobj)
        }
      } else {
        assertNever(data);
      }
    }
  }

  return {
    register: register,
    samplePortName: 'googleAnalyticsFromElm'
  };
}
