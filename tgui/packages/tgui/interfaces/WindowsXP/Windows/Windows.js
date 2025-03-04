import { Window } from './Window';
import React from 'react';

export class Windows extends React.Component {
  render() {
    const { apps, current_app, act } = this.props;
    return (
      <>
        {apps.map((app) => {
          return (
            app.launched === 1 &&
            app.reference !== current_app && <Window app={app} act={act} />
          );
        })}
        {apps.map((app) => {
          return (
            app.launched === 1 &&
            app.reference === current_app && (
              <Window app={app} act={act} is_Focus />
            )
          );
        })}
      </>
    );
  }
}
