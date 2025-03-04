import { Window } from '../layouts';
import { WinXP } from './WindowsXP/index';
import { useBackend } from '../backend';
import React from 'react';

export class WindowsXP extends React.Component {
  render() {
    const { act, data } = useBackend(this.context);
    return (
      <Window width={1200} height={678} theme="light">
        <WinXP data={data} act={act} />
      </Window>
    );
  }
}
