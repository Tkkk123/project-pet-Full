export interface OpenClawResponse {
  success: boolean;
  data: {
    id: string;
    object: string;
    created: number;
    model: string;
    choices: {
      index: number;
      message: { role: string; content: string };
      finish_reason: string;
    }[];
  };
}

export interface ChatRequestPayload {
  message: string;
}

