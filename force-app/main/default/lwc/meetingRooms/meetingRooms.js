import { LightningElement } from 'lwc';

export default class MeetingRooms extends LightningElement {
    meetingRoomsInfo = [
        {roomName:'A-01',roomCapacity:'10'},
        {roomName:'A-02',roomCapacity:'6'},
        {roomName:'A-03',roomCapacity:'25'},
        {roomName:'B-01',roomCapacity:'8'},
        {roomName:'B-02',roomCapacity:'18'},
        {roomName:'B-03',roomCapacity:'30'},
        {roomName:'C-01',roomCapacity:'4'},
        {roomName:'C-02',roomCapacity:'15'},
        {roomName:'C-03',roomCapacity:'12'}
    ]
}