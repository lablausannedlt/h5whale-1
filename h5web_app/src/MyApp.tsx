import { App, createBasicFetcher, H5GroveProvider } from '@h5web/app';
import './deeplight_theme.css';   // <-- add this

const fetcher = createBasicFetcher();

function MyApp() {
  const query = new URLSearchParams(globalThis.location.search);
  const file = query.get('file');
  const url = import.meta.env.VITE_H5GROVE_URL as string;
  const port = import.meta.env.VITE_H5GROVE_PORT as string;

  if (!file) {
    return (
      <p>
        Provide a file name by adding
        <pre>?file=...</pre>
        to the URL.
      </p>
    );
  }

  return (
    <H5GroveProvider
      url={port ? `${url}:${port}` : url}
      filepath={file}
      fetcher={fetcher}
    >
      {/* Wrapper enables palette override */}
      <div className="deeplight-h5web">
        <App />
      </div>
    </H5GroveProvider>
  );
}

export default MyApp;
