from util.db_conn_util import get_connection

class AdoptionEventDAO:
    def get_all_events(self):
        events = []
        try:
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM adoption_events")
            rows = cursor.fetchall()
            for row in rows:
                event = {
                    "EventID": row[0],
                    "EventName": row[1],
                    "EventDate": row[2],
                    "Location": row[3]
                }
                events.append(event)
        except Exception as e:
            print("Error fetching events:", e)
        finally:
            if conn:
                conn.close()
        return events

    def register_participant(self, event_id: int, name: str, participant_type: str):
        try:
            conn = get_connection()
            cursor = conn.cursor()
            insert_query = """
                INSERT INTO participants (EventID, ParticipantName, ParticipantType)
                VALUES (?, ?, ?)
            """
            cursor.execute(insert_query, (event_id, name, participant_type))
            conn.commit()
            print(f"{participant_type} '{name}' registered for event ID {event_id}.")
        except Exception as e:
            print("Error registering participant:", e)
        finally:
            if conn:
                conn.close()
