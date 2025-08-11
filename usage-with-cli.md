## Usage with CLI

```sh
mkdir ope
cd ope
npm init
npm i nodality cli
nodality-cli create opo   
cd opo
npm run build
npm start
nodality-cli component Nice
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>opoa</title>

  <script type="importmap">
  {
    "imports": {
      "nodality": "/dist/lib.bundle.js"
    }
  }
  </script>
</head>
<body>
  <div id="mount"></div>

  <script type="module" src="/src/app.js"></script>

    <script type="module">
      import {Nice} from "./Nice.js";
      console.log("EKI");
      console.log( new Nice("2025").render()); // npm run build && npm start
      new Nice({year: "2025"}).mount("#mount");
    </script>
</body>
</html>
```


Nice.js
```js

import * as Nodality from "nodality";

class Nice extends Base {
    constructor(props) {
        super();
        this.props = props;
    }

    render(){
        return new Text(this.props.year)
        .set({
            color: "#1abc9c"
        });
    }
}

export {Nice};
```